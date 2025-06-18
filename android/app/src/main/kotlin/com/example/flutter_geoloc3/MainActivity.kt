package com.example.flutter_geoloc3

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Flutter を起動せず Kotlin 画面に遷移
        val intent = Intent(this, WifiLocationActivity::class.java)
        startActivity(intent)
        finish()
    }
}
