package com.example.volume

import android.content.Context
import android.media.AudioManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "beny.native/volume"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        /// MethodChannel is used to communicate between Flutter and native Android code.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "setRingtoneVolume") {
                    val volume = call.argument<Int>("volume")
                    setRingtoneVolume(applicationContext, volume ?: 0)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    /// Sets the ringtone volume to the given value.
    private fun setRingtoneVolume(context: Context, volume: Int) {
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        audioManager?.let {
            val maxVolume = it.getStreamMaxVolume(AudioManager.STREAM_RING)
            val adjustedVolume = volume * maxVolume / 100
            it.setStreamVolume(AudioManager.STREAM_RING, adjustedVolume, 0)
        }
    }
}
