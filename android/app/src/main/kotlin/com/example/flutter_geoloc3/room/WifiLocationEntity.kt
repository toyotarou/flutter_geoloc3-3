package com.example.flutter_geoloc3.room

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "wifi_location")
data class WifiLocationEntity(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val date: String,
    val time: String,
    val ssid: String,
    val latitude: String,
    val longitude: String
)
