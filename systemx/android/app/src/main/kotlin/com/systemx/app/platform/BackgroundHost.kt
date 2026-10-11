package com.systemx.app.platform

import android.content.Context
import com.systemx.app.background.BackgroundBridge

/** Implements the Pigeon BackgroundApi on top of the background package. */
class BackgroundHost(context: Context) : BackgroundApi {
    private val ctx = context.applicationContext

    override fun getConfig() = BackgroundBridge.config(ctx)
    override fun setConfig(config: BackgroundConfig) = BackgroundBridge.setConfig(ctx, config)
    override fun history(sinceMs: Long) = BackgroundBridge.history(ctx, sinceMs)
    override fun sessions(limit: Long) = BackgroundBridge.sessions(ctx, limit.toInt())
    override fun clearHistory() = BackgroundBridge.clear(ctx)
    override fun refreshWidgets() = BackgroundBridge.refreshWidgets(ctx)
    override fun notificationsEnabled() = BackgroundBridge.notificationsEnabled(ctx)
}
