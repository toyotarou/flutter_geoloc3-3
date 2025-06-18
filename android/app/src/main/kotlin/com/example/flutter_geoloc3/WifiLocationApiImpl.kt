package com.example.flutter_geoloc3

import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.flutter_geoloc3.room.AppDatabase
import com.example.flutter_geoloc3.room.WifiLocationEntity
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

class WifiLocationApiImpl(
    private val context: Context
) : WifiLocationApi {

    ///
    override fun getWifiLocations(): List<WifiLocation> {
        val dao = AppDatabase
            .getDatabase(context)
            .wifiLocationDao()

        // Flow → List に変換
        val entityList: List<WifiLocationEntity> = runBlocking {
            dao.getAll().first()
        }

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

    ///
    override fun deleteAllWifiLocations() {
        val dao = AppDatabase
            .getDatabase(context)
            .wifiLocationDao()

        runBlocking {
            dao.deleteAll()
        }
    }

    ///
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

        // サービス稼働状態フラグを明示的に true に
        WifiForegroundService.isRunning = true
    }

    ///
    override fun isCollecting(): Boolean {
        return WifiForegroundService.isRunning
    }
}
