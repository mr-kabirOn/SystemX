package com.systemx.app.background

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Restores live status and the charger watch after a restart or an update. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED, Intent.ACTION_MY_PACKAGE_REPLACED -> try {
                Scheduler.apply(context)
            } catch (_: Exception) {
            }
        }
    }
}
