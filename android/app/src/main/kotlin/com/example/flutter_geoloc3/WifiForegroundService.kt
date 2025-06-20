package com.example.flutter_geoloc3

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.location.Location
import android.net.wifi.WifiManager
import android.os.Build
import android.os.IBinder
import android.util.Log
import com.example.flutter_geoloc3.room.AppDatabase
import com.example.flutter_geoloc3.room.WifiLocationEntity
import com.google.android.gms.location.LocationServices
import kotlinx.coroutines.*
import java.text.SimpleDateFormat
import java.util.*
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

/**
 * 位置情報とWi-Fi SSIDを1分おきに取得し、
 * Roomデータベースに保存するフォアグラウンドサービス。
 */
class WifiForegroundService : Service() {

    companion object {
        // サービス稼働状態のフラグ
        var isRunning: Boolean = false

        // 通知チャネルID
        private const val CHANNEL_ID = "WifiLocationServiceChannel"
    }

    // 繰り返し実行用のジョブ
    private var job: Job? = null

    override fun onCreate() {
        super.onCreate()
        isRunning = true

        // 通知チャネルを作成し、通知を表示
        createNotificationChannel()
        val notification = createNotification("Wi-Fi位置情報取得中...")

        // Android 14以降の対応
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                1,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
            )
        } else {
            startForeground(1, notification)
        }

        // データ取得開始
        startCollecting()
    }

    override fun onDestroy() {
        isRunning = false
        job?.cancel() // ジョブ停止
        super.onDestroy()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {
        // サービスが終了しても自動で再起動
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    /**
     * Wi-Fi SSIDと位置情報を定期的に取得して保存
     */
    private fun startCollecting() {
        val dao = AppDatabase.getDatabase(this).wifiLocationDao()
        val wifiManager = applicationContext
            .getSystemService(Context.WIFI_SERVICE) as WifiManager
        val fusedLocationClient = LocationServices
            .getFusedLocationProviderClient(this)

        job = CoroutineScope(Dispatchers.IO).launch {
            while (true) {
                try {
                    val now = Date()

                    val sdfDate = SimpleDateFormat(
                        "yyyy-MM-dd", Locale.getDefault()
                    )
                    val sdfTime = SimpleDateFormat(
                        "HH:mm:ss", Locale.getDefault()
                    )

                    // 現在接続中のWi-Fi SSIDを取得
                    val ssid = wifiManager.connectionInfo.ssid ?: "Unknown"

                    // 位置情報の取得（非同期）
                    val location: Location? = try {
                        suspendCancellableCoroutine { cont ->
                            fusedLocationClient.lastLocation
                                .addOnSuccessListener {
                                    cont.resume(it, null)
                                }
                                .addOnFailureListener {
                                    cont.resume(null, null)
                                }
                        }
                    } catch (e: Exception) {
                        null
                    }

                    if (location != null) {
                        // エンティティを作成してDBに保存
                        val entity = WifiLocationEntity(
                            date = sdfDate.format(now),
                            time = sdfTime.format(now),
                            ssid = ssid,
                            latitude = location.latitude.toString(),
                            longitude = location.longitude.toString()
                        )
                        dao.insert(entity)

                        Log.d(
                            "WifiForegroundService",
                            "✅ 位置情報を保存しました: $entity"
                        )
                    } else {
                        Log.w(
                            "WifiForegroundService",
                            "⚠ 位置情報が取得できませんでした"
                        )
                    }

                    delay(60_000) // 1分待機
                } catch (e: Exception) {
                    Log.e(
                        "WifiForegroundService",
                        "❌ データ保存中にエラー",
                        e
                    )
                }
            }
        }
    }

    /**
     * 通知チャネルを作成（Android O以降）
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Wi-Fi位置情報取得サービス",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(
                NotificationManager::class.java
            )
            manager.createNotificationChannel(serviceChannel)
        }
    }

    /**
     * フォアグラウンド通知を構築
     */
    private fun createNotification(content: String): Notification {
        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Wi-Fi位置情報取得")
            .setContentText(content)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .build()
    }
}
