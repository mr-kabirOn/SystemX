package com.systemx.app.background

import android.content.Context
import com.systemx.app.platform.BackgroundConfig
import com.systemx.app.platform.ChargeSession
import com.systemx.app.platform.HistorySample

/** Public entry points for the Pigeon host; the rest of the package stays internal. */
object BackgroundBridge {
    fun config(ctx: Context): BackgroundConfig = ConfigStore.load(ctx)

    fun setConfig(ctx: Context, c: BackgroundConfig) {
        ConfigStore.save(ctx, c)
        Scheduler.apply(ctx)
    }

    fun history(ctx: Context, sinceMs: Long): List<HistorySample> = HistoryDb.get(ctx).samples(sinceMs)

    fun sessions(ctx: Context, limit: Int): List<ChargeSession> = HistoryDb.get(ctx).sessions(limit)

    fun clear(ctx: Context) = HistoryDb.get(ctx).clear()

    fun refreshWidgets(ctx: Context) = WidgetUpdater.update(ctx, Readings.read(ctx))

    fun notificationsEnabled(ctx: Context) = Notifications.canPost(ctx)

    /** Called when the app opens: records a sample and makes sure work is scheduled. */
    fun onAppStart(ctx: Context) {
        try {
            Scheduler.apply(ctx)
            Sampler.onReading(ctx, Readings.read(ctx))
        } catch (_: Exception) {
        }
    }
}
