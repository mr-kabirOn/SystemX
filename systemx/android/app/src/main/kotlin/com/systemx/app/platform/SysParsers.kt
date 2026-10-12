package com.systemx.app.platform

/**
 * Pure parsers for system files and raw values. No Android imports, so they
 * run in plain JVM unit tests (app/src/test).
 */
internal object SysParsers {
    private val PROP_LINE = Regex("""^\[(.+?)]: \[(.*)]$""")
    private val WHITESPACE = Regex("\\s+")
    private val BLANK_LINE = Regex("\\n\\s*\\n")

    /** `getprop` output ("[key]: [value]" per line) as a map. */
    fun getprop(lines: Sequence<String>): Map<String, String> =
        lines.mapNotNull { PROP_LINE.find(it)?.destructured }
            .associate { (k, v) -> k to v }

    /** /proc/meminfo values in kB, keyed by name ("MemTotal"...). */
    fun meminfo(lines: List<String>): Map<String, Long> = lines.mapNotNull { line ->
        val parts = line.trim().split(WHITESPACE)
        if (parts.size < 2) return@mapNotNull null
        val value = parts[1].toLongOrNull() ?: return@mapNotNull null
        parts[0].trimEnd(':') to value
    }.toMap()

    /** /proc/cpuinfo as one key/value map per blank-line separated block. */
    fun cpuinfo(text: String): List<Map<String, String>> =
        text.split(BLANK_LINE).map { block ->
            block.lines().mapNotNull { line ->
                val idx = line.indexOf(':')
                if (idx <= 0) null else line.substring(0, idx).trim() to line.substring(idx + 1).trim()
            }.toMap()
        }.filter { it.isNotEmpty() }

    /** Core name from /proc/cpuinfo "CPU implementer" and "CPU part" (hex). */
    fun cpuPartName(implementer: String?, part: String?): String? {
        val impl = implementer?.lowercase()?.removePrefix("0x")?.toIntOrNull(16) ?: return null
        val p = part?.lowercase()?.removePrefix("0x")?.toIntOrNull(16) ?: return null
        return when (impl) {
            0x41 -> ARM_PARTS[p]
            0x51 -> QCOM_PARTS[p]
            0x53 -> SAMSUNG_PARTS[p]
            else -> null
        }
    }

    /** File system type of [mountPoint] from /proc/mounts lines. */
    fun mountFsType(lines: List<String>, mountPoint: String): String? =
        lines.map { it.split(' ') }
            .firstOrNull { it.size > 2 && it[1] == mountPoint }
            ?.get(2)

    /** Some phones report volts instead of millivolts. */
    fun voltageMv(raw: Int): Int = if (raw in 1..20) raw * 1000 else raw

    /**
     * Android specifies microamps with positive = charging, but many phones
     * report milliamps and some flip the sign. Returns milliamps, positive
     * while charging.
     */
    fun currentMa(raw: Int, charging: Boolean): Long {
        val ma = if (kotlin.math.abs(raw) > 20_000) raw / 1000 else raw
        return when {
            charging && ma < 0 -> -ma
            !charging && ma > 0 -> -ma
            else -> ma
        }.toLong()
    }

    /** Charge counter in mAh; the API says µAh but some phones report mAh. */
    fun chargeCounterMah(raw: Int): Long = (if (raw > 100_000) raw / 1000 else raw).toLong()

    /** Vulkan version packed as in VK_MAKE_VERSION, or null for 0. */
    fun vulkanVersion(packed: Int): String? {
        if (packed == 0) return null
        return "${packed shr 22}.${(packed shr 12) and 0x3ff}.${packed and 0xfff}"
    }

    /**
     * Thermal zones that measure the CPU, from each zone's "type" file
     * (e.g. "cpu-1-0-usr", "mtktscpu", "cpuss-0", "soc_thermal"). GPU, battery,
     * skin and modem sensors are left out.
     */
    fun cpuThermalZones(types: Map<Int, String>): List<Int> = types.filter { (_, raw) ->
        val t = raw.lowercase()
        val cpuLike = t.startsWith("cpu") || t.contains("tscpu") || t.contains("cpu_therm") ||
            t.contains("cpuss") || t == "soc_thermal" || t.startsWith("big") || t.startsWith("little") ||
            t.startsWith("mid") || t.startsWith("tsens_tz_sensor")
        val excluded = listOf("gpu", "batt", "skin", "modem", "pa_", "xo", "usb", "charger", "camera")
            .any { t.contains(it) }
        cpuLike && !excluded
    }.keys.sorted()

    /** A thermal zone reading in °C (files hold millidegrees or degrees), or null if implausible. */
    fun thermalC(raw: Long): Double? {
        val c = if (kotlin.math.abs(raw) >= 1000) raw / 1000.0 else raw.toDouble()
        return c.takeIf { it > 0 && it < 150 }
    }

    /** Samsung's ro.build.version.oneui ("80000", "60100") as "8.0", "6.1". */
    fun oneUiVersion(raw: String?): String? {
        val n = raw?.trim()?.toIntOrNull()?.takeIf { it >= 10000 } ?: return null
        val minor = n % 10000 / 100
        val patch = n % 100
        return if (patch > 0) "${n / 10000}.$minor.$patch" else "${n / 10000}.$minor"
    }

    /** A battery cycle count from sysfs or the battery intent; 0 or less means unknown. */
    fun cycleCount(raw: Long?): Long? = raw?.takeIf { it in 1..20_000 }

    private val ARM_PARTS = mapOf(
        0xd03 to "Cortex-A53", 0xd04 to "Cortex-A35", 0xd05 to "Cortex-A55", 0xd07 to "Cortex-A57",
        0xd08 to "Cortex-A72", 0xd09 to "Cortex-A73", 0xd0a to "Cortex-A75", 0xd0b to "Cortex-A76",
        0xd0d to "Cortex-A77", 0xd41 to "Cortex-A78", 0xd44 to "Cortex-X1", 0xd46 to "Cortex-A510",
        0xd47 to "Cortex-A710", 0xd48 to "Cortex-X2", 0xd4d to "Cortex-A715", 0xd4e to "Cortex-X3",
        0xd80 to "Cortex-A520", 0xd81 to "Cortex-A720", 0xd82 to "Cortex-X4", 0xd85 to "Cortex-X925",
        0xd87 to "Cortex-A725",
    )
    private val QCOM_PARTS = mapOf(
        0x800 to "Kryo Gold", 0x801 to "Kryo Silver", 0x802 to "Kryo Gold", 0x803 to "Kryo Silver",
        0x804 to "Kryo Gold", 0x805 to "Kryo Silver", 0x001 to "Oryon",
    )
    private val SAMSUNG_PARTS = mapOf(0x001 to "Mongoose M1", 0x002 to "Mongoose M3", 0x003 to "Mongoose M4", 0x004 to "Mongoose M5")
}
