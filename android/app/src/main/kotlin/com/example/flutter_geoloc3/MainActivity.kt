package com.example.flutter_geoloc3

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle

import com.example.flutter_geoloc3.WifiLocationApi
import com.example.flutter_geoloc3.WifiLocationApiImpl
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        // Flutter を起動せず Kotlin 画面に遷移
//        val intent = Intent(this, WifiLocationActivity::class.java)
//        startActivity(intent)
//        finish()
//    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Kotlin 側の API 実装を登録
        WifiLocationApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            WifiLocationApiImpl(this)
        )
    }
}
