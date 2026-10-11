package com.systemx.app.background

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.widget.RemoteViews
import com.systemx.app.R
import com.systemx.app.platform.AlertRules
import kotlin.math.roundToInt

/** Small widget: battery level and temperature. */
class SmallWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) =
        WidgetUpdater.update(context, Readings.read(context))
}

/** Medium widget: battery, temperature, RAM and free storage. */
class MediumWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) =
        WidgetUpdater.update(context, Readings.read(context))
}

internal object WidgetUpdater {
    fun update(context: Context, r: Reading) {
        val ctx = context.applicationContext
        val manager = AppWidgetManager.getInstance(ctx) ?: return
        val c = ConfigStore.load(ctx)
        val temp = AlertRules.temp(r.tempC, c.fahrenheit)
        val level = if (r.level >= 0) "${r.level}%" else "–"
        val open = Notifications.openApp(ctx, "/home", 3)

        val small = manager.getAppWidgetIds(ComponentName(ctx, SmallWidget::class.java))
        if (small.isNotEmpty()) {
            val v = RemoteViews(ctx.packageName, R.layout.widget_small).apply {
                setTextViewText(R.id.w_level, level)
                setTextViewText(R.id.w_temp, temp)
                setTextViewText(R.id.w_state, ctx.getString(if (r.pluggedIn) R.string.w_charging else R.string.w_battery))
                setOnClickPendingIntent(R.id.w_root, open)
            }
            manager.updateAppWidget(small, v)
        }

        val medium = manager.getAppWidgetIds(ComponentName(ctx, MediumWidget::class.java))
        if (medium.isNotEmpty()) {
            val freeGb = r.storageFree / 1e9
            val v = RemoteViews(ctx.packageName, R.layout.widget_medium).apply {
                setTextViewText(R.id.w_level, level)
                setTextViewText(R.id.w_temp, temp)
                setTextViewText(R.id.w_ram, ctx.getString(R.string.w_ram, (r.memUsed * 100).roundToInt()))
                setTextViewText(
                    R.id.w_storage,
                    ctx.getString(R.string.w_free, if (freeGb >= 100) "${freeGb.roundToInt()} GB" else "${"%.1f".format(freeGb)} GB"),
                )
                setProgressBar(R.id.w_bar, 100, r.level.coerceIn(0, 100), false)
                setOnClickPendingIntent(R.id.w_root, open)
            }
            manager.updateAppWidget(medium, v)
        }
    }
}
