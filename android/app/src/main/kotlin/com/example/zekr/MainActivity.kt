package com.example.zekr

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.os.Build
import android.os.Bundle
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "zekr_channel"
            val channelName = "zekr"
            val importance = NotificationManager.IMPORTANCE_HIGH

            // مسار ملف الصوت
            val soundUri = Uri.parse("android.resource://${packageName}/${R.raw.song}")

            // إعدادات الصوت
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            // إنشاء القناة
            val mChannel = NotificationChannel(channelId, channelName, importance).apply {
                setSound(soundUri, audioAttributes) // إضافة الصوت
                enableLights(true)
                enableVibration(true)
            }

            // تسجيل القناة
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
        }
    }

    
}
