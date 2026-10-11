package com.systemx.app.platform

import android.Manifest
import android.app.KeyguardManager
import android.app.admin.DevicePolicyManager
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.biometrics.BiometricManager
import android.os.Build
import android.os.SystemClock
import android.provider.Settings
import java.io.File
import java.util.Locale
import java.util.TimeZone

/** Device identity, OS details and the security checklist. */
internal class SystemProbe(private val ctx: Context) {

    fun identity(): DeviceIdentity {
        val market = Sys.firstProp(
            "ro.product.marketname",
            "ro.product.vendor.marketname",
            "ro.product.odm.marketname",
            "ro.config.marketing_name",
            "ro.vendor.product.display",
        ) ?: samsungName() ?: Build.MODEL

        return DeviceIdentity(
            manufacturer = Build.MANUFACTURER.replaceFirstChar { it.titlecase(Locale.ROOT) },
            brand = Build.BRAND.replaceFirstChar { it.titlecase(Locale.ROOT) },
            model = Build.MODEL,
            marketName = market,
            codename = Build.DEVICE,
            product = Build.PRODUCT,
            board = Build.BOARD,
            hardware = Build.HARDWARE,
            isTablet = ctx.resources.configuration.smallestScreenWidthDp >= 600,
        )
    }

    /** Samsung keeps the marketing name ("Galaxy A54 5G") as the default device name. */
    private fun samsungName(): String? {
        if (!Build.MANUFACTURER.equals("samsung", ignoreCase = true)) return null
        return Sys.safe { Settings.Global.getString(ctx.contentResolver, Settings.Global.DEVICE_NAME) }
            ?.takeIf { it.startsWith("Galaxy", ignoreCase = true) }
    }

    fun system(): SystemInfo {
        val pm = ctx.packageManager
        fun pkgVersion(name: String) = Sys.safe { pm.getPackageInfo(name, 0).versionName }

        return SystemInfo(
            release = Build.VERSION.RELEASE,
            sdk = Build.VERSION.SDK_INT.toLong(),
            securityPatch = Build.VERSION.SECURITY_PATCH.ifBlank { null },
            buildId = Build.ID,
            buildDisplay = Build.DISPLAY,
            fingerprint = Build.FINGERPRINT,
            incremental = Build.VERSION.INCREMENTAL,
            buildType = Build.TYPE,
            tags = Build.TAGS ?: "",
            buildTimeMs = Build.TIME,
            bootloader = Build.BOOTLOADER,
            baseband = Sys.safe { Build.getRadioVersion() }?.ifBlank { null },
            kernel = System.getProperty("os.version") ?: Sys.read("/proc/version") ?: "",
            vm = listOfNotNull(System.getProperty("java.vm.name"), System.getProperty("java.vm.version"))
                .joinToString(" "),
            uptimeMs = SystemClock.elapsedRealtime(),
            locale = Locale.getDefault().toLanguageTag(),
            timezone = TimeZone.getDefault().id,
            playServices = pkgVersion("com.google.android.gms"),
            playStore = pkgVersion("com.android.vending"),
            playSystemUpdate = pkgVersion("com.google.android.modulemetadata"),
            treble = Sys.prop("ro.treble.enabled")?.let { it == "true" },
            seamlessUpdates = Sys.prop("ro.build.ab_update")?.let { it == "true" } ?: false,
            dynamicPartitions = Sys.prop("ro.boot.dynamic_partitions")?.let { it == "true" } ?: false,
            rootDetected = rootDetected(),
            encryption = encryption(),
        )
    }

    fun security(): SecurityInfo {
        val km = ctx.getSystemService(KeyguardManager::class.java)
        val cr = ctx.contentResolver
        val lockedProp = Sys.prop("ro.boot.flash.locked")
        val vbmetaState = Sys.prop("ro.boot.vbmeta.device_state")
        return SecurityInfo(
            screenLock = km?.isDeviceSecure ?: false,
            encryption = encryption(),
            securityPatch = Build.VERSION.SECURITY_PATCH.ifBlank { null },
            devOptions = Sys.safe {
                Settings.Global.getInt(cr, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) == 1
            } ?: false,
            adb = Sys.safe { Settings.Global.getInt(cr, Settings.Global.ADB_ENABLED, 0) == 1 } ?: false,
            verifiedBoot = Sys.prop("ro.boot.verifiedbootstate"),
            bootloaderLocked = when {
                lockedProp != null -> lockedProp == "1"
                vbmetaState != null -> vbmetaState == "locked"
                else -> null
            },
            rootDetected = rootDetected(),
            biometricStatus = biometricStatus(),
        )
    }

    private fun encryption(): String {
        val dpm = ctx.getSystemService(DevicePolicyManager::class.java) ?: return "unknown"
        return when (Sys.safe { dpm.storageEncryptionStatus }) {
            DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE,
            DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE_PER_USER,
            DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE_DEFAULT_KEY -> "encrypted"
            DevicePolicyManager.ENCRYPTION_STATUS_INACTIVE -> "unencrypted"
            else -> "unknown"
        }
    }

    /** Informational only: looks for common su binaries and test-keys builds. */
    private fun rootDetected(): Boolean {
        val paths = listOf(
            "/system/bin/su", "/system/xbin/su", "/sbin/su", "/system/sbin/su",
            "/vendor/bin/su", "/su/bin/su", "/data/adb/magisk", "/system/app/Superuser.apk",
        )
        return paths.any { Sys.safe { File(it).exists() } == true } ||
            (Build.TAGS?.contains("test-keys") == true)
    }

    private fun biometricStatus(): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return "unavailable"
        if (ctx.checkSelfPermission(Manifest.permission.USE_BIOMETRIC) != PackageManager.PERMISSION_GRANTED) {
            return "unavailable"
        }
        val bm = ctx.getSystemService(BiometricManager::class.java) ?: return "unavailable"
        val result = Sys.safe {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                bm.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_WEAK)
            } else {
                @Suppress("DEPRECATION") bm.canAuthenticate()
            }
        } ?: return "unavailable"
        return when (result) {
            BiometricManager.BIOMETRIC_SUCCESS -> "enrolled"
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> "none_enrolled"
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> "no_hardware"
            else -> "unavailable"
        }
    }
}
