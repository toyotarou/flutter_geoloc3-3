# Flutter関連コードを保持
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Roomのための設定（Kotlin用 SQLite）
-keep class androidx.room.** { *; }
-keep class ** extends androidx.room.RoomDatabase
-keep class ** extends androidx.room.RoomDatabase_Impl
-keepclassmembers class * {
    @androidx.room.* <methods>;
    @androidx.room.* <fields>;
}

# Kotlinコルーチン関連
-dontwarn kotlinx.coroutines.**

# Kotlinのメタ情報
-keepclassmembers class ** {
    @kotlin.Metadata *;
}
