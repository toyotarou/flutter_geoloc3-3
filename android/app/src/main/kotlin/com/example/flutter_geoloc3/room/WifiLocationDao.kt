package com.example.flutter_geoloc3.room

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface WifiLocationDao {

    @Insert
    suspend fun insert(location: WifiLocationEntity)

    @Query("SELECT * FROM wifi_location")
    fun getAll(): Flow<List<WifiLocationEntity>>

    @Query("DELETE FROM wifi_location")
    suspend fun deleteAll()

    @Delete
    suspend fun delete(location: WifiLocationEntity)

}
