package com.systemx.app.platform

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class SysParsersTest {

    @Test
    fun getpropReadsKeysAndKeepsEmptyValues() {
        val props = SysParsers.getprop(
            sequenceOf(
                "[ro.product.marketname]: [Galaxy A54 5G]",
                "[ro.treble.enabled]: [true]",
                "[ro.empty]: []",
                "garbage line",
            ),
        )
        assertEquals("Galaxy A54 5G", props["ro.product.marketname"])
        assertEquals("true", props["ro.treble.enabled"])
        assertEquals("", props["ro.empty"])
        assertEquals(3, props.size)
    }

    @Test
    fun meminfoParsesKilobytes() {
        val mem = SysParsers.meminfo(
            listOf(
                "MemTotal:        7816000 kB",
                "MemAvailable:    2970000 kB",
                "SwapTotal:       8388604 kB",
                "HugePages_Total:       0",
                "Broken line",
            ),
        )
        assertEquals(7_816_000L, mem["MemTotal"])
        assertEquals(8_388_604L, mem["SwapTotal"])
        assertEquals(0L, mem["HugePages_Total"])
        assertNull(mem["Broken"])
    }

    @Test
    fun cpuinfoSplitsBlocksPerCore() {
        val text = """
            processor	: 0
            BogoMIPS	: 49.15
            CPU implementer	: 0x41
            CPU part	: 0xd46

            processor	: 8
            CPU implementer	: 0x41
            CPU part	: 0xd4e

            Hardware	: Qualcomm Technologies, Inc SM8650
        """.trimIndent()
        val blocks = SysParsers.cpuinfo(text)
        assertEquals(3, blocks.size)
        assertEquals("0", blocks[0]["processor"])
        assertEquals("0xd4e", blocks[1]["CPU part"])
        assertEquals("Qualcomm Technologies, Inc SM8650", blocks[2]["Hardware"])
    }

    @Test
    fun cpuPartNamesFromImplementerAndPart() {
        assertEquals("Cortex-A510", SysParsers.cpuPartName("0x41", "0xd46"))
        assertEquals("Cortex-X3", SysParsers.cpuPartName("0x41", "0xD4E"))
        assertEquals("Kryo Silver", SysParsers.cpuPartName("0x51", "0x805"))
        assertNull(SysParsers.cpuPartName("0x48", "0xd40"))
        assertNull(SysParsers.cpuPartName(null, "0xd46"))
        assertNull(SysParsers.cpuPartName("0x41", "not hex"))
    }

    @Test
    fun mountFsTypeFindsTheDataPartition() {
        val mounts = listOf(
            "/dev/block/dm-5 / ext4 ro,seclabel 0 0",
            "/dev/block/dm-48 /data f2fs rw,lazytime 0 0",
            "/dev/block/dm-48 /data/user/0 f2fs rw 0 0",
        )
        assertEquals("f2fs", SysParsers.mountFsType(mounts, "/data"))
        assertNull(SysParsers.mountFsType(mounts, "/vendor"))
    }

    @Test
    fun voltageAcceptsVoltsOrMillivolts() {
        assertEquals(4210, SysParsers.voltageMv(4210))
        assertEquals(4000, SysParsers.voltageMv(4))
        assertEquals(0, SysParsers.voltageMv(0))
    }

    @Test
    fun currentIsMilliampsAndPositiveWhileCharging() {
        // Microamps, correct sign.
        assertEquals(2140L, SysParsers.currentMa(2_140_000, charging = true))
        // Milliamps with the sign flipped by the maker.
        assertEquals(2140L, SysParsers.currentMa(-2140, charging = true))
        assertEquals(-450L, SysParsers.currentMa(450_000, charging = false))
        assertEquals(-450L, SysParsers.currentMa(-450, charging = false))
    }

    @Test
    fun chargeCounterAcceptsMicroOrMilliampHours() {
        assertEquals(3284L, SysParsers.chargeCounterMah(3_284_000))
        assertEquals(3284L, SysParsers.chargeCounterMah(3284))
    }

    @Test
    fun vulkanVersionUnpacks() {
        // VK_MAKE_VERSION(1, 3, 278)
        assertEquals("1.3.278", SysParsers.vulkanVersion((1 shl 22) or (3 shl 12) or 278))
        assertNull(SysParsers.vulkanVersion(0))
        assertTrue(SysParsers.vulkanVersion(1 shl 22)!!.startsWith("1.0"))
    }
}
