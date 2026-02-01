package com.example.oryzn

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Enable high refresh rate (120Hz) for supported devices
        enableHighRefreshRate()
    }

    private fun enableHighRefreshRate() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                // Android 11+ (API 30+): Use modern Display API
                val display = display
                if (display != null) {
                    val supportedModes = display.supportedModes

                    // Check for the highest refresh rate
                    var maxRefreshRate = 60f
                    var preferredModeId = -1

                    for (mode in supportedModes) {
                        if (mode.refreshRate > maxRefreshRate) {
                            maxRefreshRate = mode.refreshRate
                            preferredModeId = mode.modeId
                        }
                    }

                    // display mode when higher refresh rate found
                    if (preferredModeId != -1 && maxRefreshRate > 60f) {
                        val params = window.attributes
                        params.preferredDisplayModeId = preferredModeId
                        window.attributes = params
                        Log.d("MainActivity", "High refresh rate enabled: ${maxRefreshRate}Hz (Mode ID: $preferredModeId)")
                    } else {
                        Log.d("MainActivity", "Device only supports 60Hz")
                    }
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // Android 6-10 (API 23-29): Use deprecated but functional API
                @Suppress("DEPRECATION")
                val display = windowManager.defaultDisplay
                @Suppress("DEPRECATION")
                val supportedModes = display.supportedModes

                var maxRefreshRate = 60f
                var preferredModeId = -1

                for (mode in supportedModes) {
                    if (mode.refreshRate > maxRefreshRate) {
                        maxRefreshRate = mode.refreshRate
                        preferredModeId = mode.modeId
                    }
                }

                if (preferredModeId != -1 && maxRefreshRate > 60f) {
                    val params = window.attributes
                    params.preferredDisplayModeId = preferredModeId
                    window.attributes = params
                    Log.d("MainActivity", "High refresh rate enabled: ${maxRefreshRate}Hz")
                }
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to enable high refresh rate", e)
        }
    }

}
