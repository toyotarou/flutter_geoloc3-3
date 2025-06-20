package com.example.flutter_geoloc3

import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.flutter_geoloc3.room.AppDatabase
import com.example.flutter_geoloc3.room.WifiLocationEntity
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

/**
 * Flutter 側から Pigeon 経由で呼び出される実装クラス。
 * Wi-Fi 位置情報の取得・削除・サービス起動状態を管理する。
 */
class WifiLocationApiImpl(
    private val context: Context
) : WifiLocationApi {

    /**
     * Kotlin 側の Room データベースから
     * すべての Wi-Fi 位置情報を取得して、
     * Flutter 側に渡す形式（List<WifiLocation>）に変換する。
     */
    override fun getWifiLocations(): List<WifiLocation> {
        // Room の DAO を取得
        val dao = AppDatabase
            .getDatabase(context)
            .wifiLocationDao()

        // Flow を List に変換する（ブロッキング）
        val entityList: List<WifiLocationEntity> = runBlocking {
            dao.getAll().first()
        }

        // Room エンティティ → Pigeon モデル に変換
        return entityList.map { entity ->
            WifiLocation(
                date = entity.date,
                time = entity.time,
                ssid = entity.ssid,
                latitude = entity.latitude,
                longitude = entity.longitude
            )
        }
    }

    /**
     * Room に保存された Wi-Fi 位置情報を全件削除する。
     * Flutter 側の「全削除ボタン」から呼び出される。
     */
    override fun deleteAllWifiLocations() {
        val dao = AppDatabase
            .getDatabase(context)
            .wifiLocationDao()

        runBlocking {
            dao.deleteAll()
        }
    }

    /**
     * ForegroundService を起動する。
     * API レベルに応じて startForegroundService を使用。
     */
    override fun startLocationCollection() {
        val intent = Intent(
            context,
            WifiForegroundService::class.java
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }

        // サービス状態をフラグで記録（Pigeon 側から取得可能）
        WifiForegroundService.isRunning = true
    }

    /**
     * サービスが稼働中かどうかを返す。
     * Flutter 側が「サービス確認ボタン」で使用。
     */
    override fun isCollecting(): Boolean {
        return WifiForegroundService.isRunning
    }
}
