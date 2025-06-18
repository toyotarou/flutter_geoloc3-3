package com.example.flutter_geoloc3.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "wifi_coordinates")
data class WifiCoordinate(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    val date: String,
    val time: String,
    val ssid: String,
    val latitude: String,
    val longitude: String
)
