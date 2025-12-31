package com.example.nexus_frontend

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "digital_wellbeing"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "hasUsagePermission" -> {
                    result.success(hasUsagePermission())
                }

                "openUsageSettings" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                    result.success(null)
                }

                "getAppUsage" -> {
                    val start = call.argument<Long>("start")!!
                    val end = call.argument<Long>("end")!!
                    result.success(getUsage(start, end))
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun hasUsagePermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getUsage(start: Long, end: Long): List<Map<String, Any>> {
        val manager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val events = manager.queryEvents(start, end)
        val event = UsageEvents.Event()
        val result = mutableListOf<Map<String, Any>>()

        while (events.hasNextEvent()) {
            events.getNextEvent(event)

            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND &&
                event.packageName != packageName
            ) {
                result.add(
                    mapOf(
                        "package" to event.packageName,
                        "time" to event.timeStamp
                    )
                )
            }
        }
        return result
    }
}
