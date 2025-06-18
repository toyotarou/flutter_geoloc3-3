package com.example.flutter_geoloc3

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import com.example.flutter_geoloc3.room.AppDatabase
import com.example.flutter_geoloc3.room.WifiLocationEntity
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch

class WifiLocationActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            WifiLocationScreen(applicationContext)
        }
    }
}

@Composable
fun WifiLocationScreen(context: Context) {
    var isPermissionGranted by remember { mutableStateOf(false) }

    // ✅ パーミッションリクエスト処理
    if (!isPermissionGranted) {
        LocationPermissionRequest(
            onGranted = { isPermissionGranted = true },
            onDenied = {
                // 拒否された場合の処理（必要であれば）
            }
        )
        return
    }

    val isServiceRunning = remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()
    val listState = rememberLazyListState()

    val wifiLocationDao = remember {
        AppDatabase.getDatabase(context).wifiLocationDao()
    }

    val wifiList by remember {
        flow<List<WifiLocationEntity>> {
            wifiLocationDao.getAll().collect { emit(it) }
        }
    }.collectAsState(initial = emptyList())

    var remainingSeconds by remember { mutableStateOf(60) }

    LaunchedEffect(Unit) {
        while (true) {
            delay(1000)
            remainingSeconds--
            if (remainingSeconds <= 0) remainingSeconds = 60
        }
    }

    LaunchedEffect(wifiList.size) {
        if (wifiList.isNotEmpty()) {
            listState.animateScrollToItem(wifiList.lastIndex)
        }
    }

    LaunchedEffect(Unit) {
        val intent = Intent(context, WifiForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }
        isServiceRunning.value = true
    }

    Column(
        modifier = Modifier
            .padding(16.dp)
            .fillMaxSize()
    ) {
        Spacer(modifier = Modifier.height(100.dp))

        Button(onClick = {
            val intent = Intent(context, WifiForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
            isServiceRunning.value = true
        }) {
            Text("サービス開始")
        }

        Spacer(modifier = Modifier.height(8.dp))

        Button(onClick = {
            isServiceRunning.value = isServiceRunning(context)
        }) {
            Text("サービス稼働状態を確認")
        }

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = if (isServiceRunning.value) "サービスは稼働中です ✅" else "サービスは停止中です ❌",
            fontSize = 18.sp
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text("次の取得まで: ${remainingSeconds}秒", fontSize = 16.sp)

        Spacer(modifier = Modifier.height(16.dp))

        Text("📋 取得済み Wi-Fi 位置情報一覧:", fontSize = 20.sp)

        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .navigationBarsPadding(),
            state = listState
        ) {
            items(items = wifiList) { wifi ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp),
                    elevation = CardDefaults.cardElevation(4.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(12.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text("📡 SSID: ${wifi.ssid}")
                            Text("🕒 日時: ${wifi.date} ${wifi.time}")
                            Text("📍 緯度: ${wifi.latitude}")
                            Text("📍 経度: ${wifi.longitude}")
                        }
                        Button(
                            onClick = {
                                scope.launch {
                                    wifiLocationDao.delete(wifi)
                                }
                            },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color.Red,
                                contentColor = Color.White
                            )
                        ) {
                            Text("削除")
                        }
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
    }
}

@Composable
fun LocationPermissionRequest(
    onGranted: () -> Unit,
    onDenied: () -> Unit = {}
) {
    val context = LocalContext.current

    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            onGranted()
        } else {
            onDenied()
        }
    }

    LaunchedEffect(Unit) {
        if (ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            permissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
        } else {
            onGranted()
        }
    }
}

fun isServiceRunning(context: Context): Boolean {
    return true
}
