package com.berlin.bible_reader

import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.berlin.bible_reader/deeplink"
    private var initialDeepLink: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialDeepLink" -> {
                        result.success(initialDeepLink)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }

        // Get initial deep link from intent
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val action = intent.action
        val uri = intent.data

        if (Intent.ACTION_VIEW == action && uri != null) {
            initialDeepLink = uri.toString()
            Log.d("MainActivity", "DeepLink received: $initialDeepLink")
            
            // Invoke method on Flutter side if engine is ready
            flutterEngine?.let { engine ->
                engine.dartExecutor.binaryMessenger?.let { binaryMessenger ->
                    try {
                        MethodChannel(binaryMessenger, CHANNEL)
                            .invokeMethod("onDeepLink", uri.toString())
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error invoking deeplink method", e)
                    }
                }
            }
        }
    }
}
