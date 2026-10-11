package com.systemx.app.platform

import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
import android.opengl.EGL14
import android.opengl.EGLConfig
import android.opengl.GLES20
import android.os.Build
import java.io.File

/** Processor (cpufreq + /proc/cpuinfo) and graphics (EGL) details. */
internal class CpuGpuProbe(private val ctx: Context) {

    private val cpuinfo: List<Map<String, String>> by lazy { parseCpuinfo() }
    private val coreCount: Int by lazy {
        Sys.safe {
            File("/sys/devices/system/cpu/").listFiles { f -> f.name.matches(Regex("cpu\\d+")) }?.size
        }?.takeIf { it > 0 } ?: Runtime.getRuntime().availableProcessors()
    }

    fun cpu(): CpuInfo {
        val header = cpuinfo.firstOrNull { it.containsKey("Hardware") } ?: emptyMap()
        val cores = (0 until coreCount).map { i -> core(i) }
        val features = cpuinfo.firstNotNullOfOrNull { it["Features"] ?: it["flags"] }

        return CpuInfo(
            socManufacturer = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                Build.SOC_MANUFACTURER.takeIf { it != Build.UNKNOWN }
            } else null,
            socModel = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                Build.SOC_MODEL.takeIf { it != Build.UNKNOWN }
            } else null,
            hardware = header["Hardware"] ?: Build.HARDWARE,
            cores = coreCount.toLong(),
            coreList = cores,
            governor = Sys.read("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"),
            abis = Build.SUPPORTED_ABIS.toList(),
            features = features,
            arch = System.getProperty("os.arch") ?: "",
        )
    }

    private fun core(i: Int): CpuCore {
        val base = "/sys/devices/system/cpu/cpu$i"
        val online = i == 0 || Sys.read("$base/online")?.let { it == "1" } ?: true
        val block = cpuinfo.firstOrNull { it["processor"] == i.toString() }
        return CpuCore(
            index = i.toLong(),
            online = online,
            minKhz = Sys.readLong("$base/cpufreq/cpuinfo_min_freq"),
            maxKhz = Sys.readLong("$base/cpufreq/cpuinfo_max_freq"),
            curKhz = if (online) {
                Sys.readLong("$base/cpufreq/scaling_cur_freq") ?: Sys.readLong("$base/cpufreq/cpuinfo_cur_freq")
            } else null,
            partName = block?.let { SysParsers.cpuPartName(it["CPU implementer"], it["CPU part"]) },
        )
    }

    private fun parseCpuinfo(): List<Map<String, String>> =
        Sys.safe { SysParsers.cpuinfo(File("/proc/cpuinfo").readText()) } ?: emptyList()

    // ---- GPU ----

    fun gpu(): GpuInfo {
        val am = ctx.getSystemService(ActivityManager::class.java)
        val gl = glStrings
        return GpuInfo(
            renderer = gl?.renderer,
            vendor = gl?.vendor,
            glVersion = gl?.version,
            glEsVersion = am?.deviceConfigurationInfo?.glEsVersion ?: "",
            vulkanVersion = vulkanVersion(),
            extensions = (gl?.extensions ?: 0).toLong(),
        )
    }

    private data class GlStrings(val renderer: String?, val vendor: String?, val version: String?, val extensions: Int)

    /** GL strings never change, so the offscreen context is created only once. */
    private val glStrings: GlStrings? by lazy { readGl() }

    private fun readGl(): GlStrings? = Sys.safe {
        val dpy = EGL14.eglGetDisplay(EGL14.EGL_DEFAULT_DISPLAY)
        val ver = IntArray(2)
        if (!EGL14.eglInitialize(dpy, ver, 0, ver, 1)) return@safe null
        try {
            val configs = arrayOfNulls<EGLConfig>(1)
            val num = IntArray(1)
            val attribs = intArrayOf(
                EGL14.EGL_RENDERABLE_TYPE, EGL14.EGL_OPENGL_ES2_BIT,
                EGL14.EGL_SURFACE_TYPE, EGL14.EGL_PBUFFER_BIT,
                EGL14.EGL_NONE,
            )
            if (!EGL14.eglChooseConfig(dpy, attribs, 0, configs, 0, 1, num, 0) || num[0] == 0) return@safe null
            val cfg = configs[0]
            val context = EGL14.eglCreateContext(
                dpy, cfg, EGL14.EGL_NO_CONTEXT,
                intArrayOf(EGL14.EGL_CONTEXT_CLIENT_VERSION, 2, EGL14.EGL_NONE), 0,
            )
            val surface = EGL14.eglCreatePbufferSurface(
                dpy, cfg, intArrayOf(EGL14.EGL_WIDTH, 1, EGL14.EGL_HEIGHT, 1, EGL14.EGL_NONE), 0,
            )
            try {
                EGL14.eglMakeCurrent(dpy, surface, surface, context)
                GlStrings(
                    renderer = GLES20.glGetString(GLES20.GL_RENDERER),
                    vendor = GLES20.glGetString(GLES20.GL_VENDOR),
                    version = GLES20.glGetString(GLES20.GL_VERSION),
                    extensions = GLES20.glGetString(GLES20.GL_EXTENSIONS)
                        ?.split(' ')?.count { it.isNotBlank() } ?: 0,
                )
            } finally {
                EGL14.eglMakeCurrent(dpy, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_CONTEXT)
                EGL14.eglDestroySurface(dpy, surface)
                EGL14.eglDestroyContext(dpy, context)
            }
        } finally {
            EGL14.eglTerminate(dpy)
        }
    }

    private fun vulkanVersion(): String? {
        val feature = ctx.packageManager.systemAvailableFeatures
            .firstOrNull { it.name == PackageManager.FEATURE_VULKAN_HARDWARE_VERSION } ?: return null
        return SysParsers.vulkanVersion(feature.version)
    }
}
