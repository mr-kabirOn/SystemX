package com.systemx.app.platform

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build

/**
 * Runtime permission requests. Android only says "permanently denied" indirectly:
 * after we have asked once, a denial with no rationale means the user chose
 * "Don't ask again" (or denied twice), so only system settings can change it.
 */
class PermissionHost(private val activity: Activity) : PermissionApi {
    private val prefs = activity.getSharedPreferences("systemx_permissions", Context.MODE_PRIVATE)
    private var pending: ((Result<String>) -> Unit)? = null
    private var pendingKind: String? = null

    private fun permissionsFor(kind: String): Array<String> = when (kind) {
        "location" -> arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
        "phone" -> arrayOf(Manifest.permission.READ_PHONE_STATE)
        "camera" -> arrayOf(Manifest.permission.CAMERA)
        "microphone" -> arrayOf(Manifest.permission.RECORD_AUDIO)
        "notifications" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            arrayOf(Manifest.permission.POST_NOTIFICATIONS)
        } else emptyArray()
        else -> emptyArray()
    }

    /** The permission that decides the result (fine location, not coarse). */
    private fun primary(kind: String) = permissionsFor(kind).firstOrNull()

    override fun status(kind: String): String {
        val p = primary(kind) ?: return "granted"
        if (activity.checkSelfPermission(p) == PackageManager.PERMISSION_GRANTED) return "granted"
        val asked = prefs.getBoolean(kind, false)
        return if (asked && !activity.shouldShowRequestPermissionRationale(p)) "blocked" else "denied"
    }

    override fun request(kind: String, callback: (Result<String>) -> Unit) {
        val perms = permissionsFor(kind)
        if (perms.isEmpty() || status(kind) == "granted") return callback(Result.success("granted"))
        if (pending != null) return callback(Result.success(status(kind)))
        pending = callback
        pendingKind = kind
        activity.requestPermissions(perms, REQUEST_CODE)
    }

    /** Called from MainActivity.onRequestPermissionsResult. */
    fun onResult(requestCode: Int) {
        if (requestCode != REQUEST_CODE) return
        val kind = pendingKind ?: return
        prefs.edit().putBoolean(kind, true).apply()
        val cb = pending
        pending = null
        pendingKind = null
        cb?.invoke(Result.success(status(kind)))
    }

    companion object {
        const val REQUEST_CODE = 4107
    }
}
