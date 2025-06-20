package com.example.flutter_geoloc3

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/**
 * Flutter 側のエントリーポイントとなる MainActivity。
 * Flutter ↔ Kotlin 間で通信する Pigeon API をここでセットアップする。
 */
class MainActivity : FlutterActivity() {

    /**
     * Flutter エンジンの初期化時に呼ばれる。
     * Kotlin 側の WifiLocationApiImpl を Flutter 側に登録する。
     */
    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        // Kotlin 実装（WifiLocationApiImpl）を Flutter 側にバインド
        WifiLocationApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            WifiLocationApiImpl(this)
        )
    }
}
