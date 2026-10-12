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

    /**
     * Retail name for a Samsung model number ("SM-S928N" -> "Galaxy S24
     * Ultra"). Samsung doesn't put the marketing name in a system property,
     * so it is looked up by the model's base code; null when not listed.
     */
    fun samsungMarketName(model: String): String? {
        val m = Regex("""^SM-([A-Z])(\d{3})""").find(model.uppercase()) ?: return null
        return SAMSUNG_MODELS[m.groupValues[1] + m.groupValues[2]]?.let { "Galaxy $it" }
    }

    private val SAMSUNG_MODELS = mapOf(
        // S series
        "S938" to "S25 Ultra", "S936" to "S25+", "S931" to "S25", "S937" to "S25 Edge", "S731" to "S25 FE",
        "S928" to "S24 Ultra", "S926" to "S24+", "S921" to "S24", "S721" to "S24 FE",
        "S918" to "S23 Ultra", "S916" to "S23+", "S911" to "S23", "S711" to "S23 FE",
        "S908" to "S22 Ultra", "S906" to "S22+", "S901" to "S22",
        "G998" to "S21 Ultra", "G996" to "S21+", "G991" to "S21", "G990" to "S21 FE",
        "G988" to "S20 Ultra", "G986" to "S20+", "G981" to "S20", "G780" to "S20 FE", "G781" to "S20 FE",
        "G975" to "S10+", "G973" to "S10", "G970" to "S10e", "G977" to "S10 5G",
        "G965" to "S9+", "G960" to "S9",
        // Note
        "N986" to "Note20 Ultra", "N985" to "Note20 Ultra", "N981" to "Note20", "N980" to "Note20",
        "N976" to "Note10+ 5G", "N975" to "Note10+", "N970" to "Note10", "N960" to "Note9",
        // Z series
        "F966" to "Z Fold7", "F956" to "Z Fold6", "F946" to "Z Fold5", "F936" to "Z Fold4", "F926" to "Z Fold3",
        "F916" to "Z Fold2", "F761" to "Z Flip7", "F741" to "Z Flip6", "F731" to "Z Flip5", "F721" to "Z Flip4",
        "F711" to "Z Flip3",
        // A series
        "A566" to "A56 5G", "A556" to "A55 5G", "A546" to "A54 5G", "A536" to "A53 5G", "A528" to "A52s 5G",
        "A526" to "A52 5G", "A525" to "A52", "A515" to "A51", "A366" to "A36 5G", "A356" to "A35 5G",
        "A346" to "A34 5G", "A336" to "A33 5G", "A325" to "A32", "A266" to "A26 5G", "A256" to "A25 5G",
        "A245" to "A24", "A235" to "A23", "A225" to "A22", "A166" to "A16 5G", "A165" to "A16",
        "A156" to "A15 5G", "A155" to "A15", "A146" to "A14 5G", "A145" to "A14", "A135" to "A13",
        "A125" to "A12", "A736" to "A73 5G", "A725" to "A72", "A715" to "A71", "A057" to "A05s",
        "A055" to "A05", "A047" to "A04s", "A045" to "A04", "A037" to "A03s", "A035" to "A03",
        // M series
        "M556" to "M55 5G", "M546" to "M54 5G", "M536" to "M53 5G", "M356" to "M35 5G", "M346" to "M34 5G",
        "M336" to "M33 5G", "M156" to "M15 5G", "M146" to "M14 5G",
        // Tablets
        "X920" to "Tab S10 Ultra", "X820" to "Tab S10+", "X910" to "Tab S9 Ultra", "X810" to "Tab S9+",
        "X710" to "Tab S9",
    )

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
