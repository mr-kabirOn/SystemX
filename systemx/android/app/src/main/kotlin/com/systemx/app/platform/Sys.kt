package com.systemx.app.platform

import java.io.File

/** Small helpers for reading system files and properties safely. */
internal object Sys {
    /** All system properties, read once with a single `getprop` call. */
    private val props: Map<String, String> by lazy {
        try {
            val process = ProcessBuilder("getprop").redirectErrorStream(true).start()
            val map = process.inputStream.bufferedReader().useLines { SysParsers.getprop(it) }
            process.waitFor()
            map
        } catch (_: Exception) {
            emptyMap()
        }
    }

    fun prop(name: String): String? = props[name]?.trim()?.ifBlank { null }

    fun firstProp(vararg names: String): String? = names.firstNotNullOfOrNull { prop(it) }

    fun read(path: String): String? = try {
        val f = File(path)
        if (f.canRead()) f.readText().trim().ifBlank { null } else null
    } catch (_: Exception) {
        null
    }

    fun readLong(path: String): Long? = read(path)?.toLongOrNull()

    fun readInt(path: String): Int? = read(path)?.toIntOrNull()

    /** Values from /proc/meminfo in kB, keyed by name ("MemTotal"...). */
    fun meminfo(): Map<String, Long> = try {
        SysParsers.meminfo(File("/proc/meminfo").readLines())
    } catch (_: Exception) {
        emptyMap()
    }

    inline fun <T> safe(block: () -> T): T? = try {
        block()
    } catch (_: Throwable) {
        null
    }
}
