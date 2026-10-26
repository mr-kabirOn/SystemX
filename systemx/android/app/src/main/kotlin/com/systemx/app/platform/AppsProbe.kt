package com.systemx.app.platform

import android.app.AppOpsManager
import android.app.usage.StorageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Process
import java.io.ByteArrayOutputStream

/**
 * Apps that show in the launcher. The manifest's launcher <queries> entry
 * makes them visible without QUERY_ALL_PACKAGES. Sizes need Usage access,
 * which the user grants in Settings.
 */
internal class AppsProbe(private val ctx: Context) {

    fun apps(): List<AppEntry> {
        val pm = ctx.packageManager
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val resolved = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.queryIntentActivities(launcher, PackageManager.ResolveInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION") pm.queryIntentActivities(launcher, 0)
        }
        val sizes = usageAccessGranted()
        val ssm = ctx.getSystemService(StorageStatsManager::class.java)
        val user = Process.myUserHandle()

        return resolved.map { it.activityInfo.packageName }.distinct().mapNotNull { name ->
            val info = Sys.safe { pm.getPackageInfo(name, 0) } ?: return@mapNotNull null
            val app = info.applicationInfo ?: return@mapNotNull null
            val stats = if (sizes) Sys.safe { ssm.queryStatsForPackage(app.storageUuid, name, user) } else null
            AppEntry(
                packageName = name,
                label = app.loadLabel(pm).toString(),
                versionName = info.versionName,
                system = app.flags and ApplicationInfo.FLAG_SYSTEM != 0,
                installedMs = info.firstInstallTime,
                updatedMs = info.lastUpdateTime,
                icon = Sys.safe { png(app.loadIcon(pm)) },
                appBytes = stats?.appBytes,
                // StorageStats counts the cache inside data; keep them apart.
                dataBytes = stats?.let { (it.dataBytes - it.cacheBytes).coerceAtLeast(0) },
                cacheBytes = stats?.cacheBytes,
            )
        }
    }

    fun usageAccessGranted(): Boolean {
        val ops = ctx.getSystemService(AppOpsManager::class.java) ?: return false
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ops.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), ctx.packageName)
        } else {
            @Suppress("DEPRECATION")
            ops.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), ctx.packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    internal fun png(d: Drawable): ByteArray {
        val bmp = Bitmap.createBitmap(ICON_PX, ICON_PX, Bitmap.Config.ARGB_8888)
        d.setBounds(0, 0, ICON_PX, ICON_PX)
        d.draw(Canvas(bmp))
        return ByteArrayOutputStream().use { out ->
            bmp.compress(Bitmap.CompressFormat.PNG, 100, out)
            bmp.recycle()
            out.toByteArray()
        }
    }

    private companion object {
        const val ICON_PX = 96
    }
}
