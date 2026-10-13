package com.systemx.app.platform

import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothStatusCodes
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.media.CamcorderProfile
import android.media.MediaCodecList
import android.media.MediaDrm
import android.net.wifi.ScanResult
import android.net.wifi.WifiManager
import android.nfc.NfcAdapter
import android.os.Build
import java.util.UUID

/** Cameras, sensors, media codecs/DRM and hardware features. */
internal class PeripheralProbe(private val ctx: Context) {

    fun cameras(): List<CameraInfo> {
        val cm = ctx.getSystemService(CameraManager::class.java) ?: return emptyList()
        return (Sys.safe { cm.cameraIdList.toList() } ?: emptyList()).mapNotNull { id ->
            Sys.safe {
                val c = cm.getCameraCharacteristics(id)
                val pixels = c.get(CameraCharacteristics.SENSOR_INFO_PIXEL_ARRAY_SIZE)
                val physical = c.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)
                val caps = c.get(CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES)?.toList() ?: emptyList()
                CameraInfo(
                    id = id,
                    facing = when (c.get(CameraCharacteristics.LENS_FACING)) {
                        CameraMetadata.LENS_FACING_FRONT -> "front"
                        CameraMetadata.LENS_FACING_BACK -> "back"
                        else -> "external"
                    },
                    pixelW = pixels?.width?.toLong(),
                    pixelH = pixels?.height?.toLong(),
                    sensorWmm = physical?.width?.toDouble(),
                    sensorHmm = physical?.height?.toDouble(),
                    apertures = c.get(CameraCharacteristics.LENS_INFO_AVAILABLE_APERTURES)
                        ?.map { it.toDouble() } ?: emptyList(),
                    focalLengths = c.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)
                        ?.map { it.toDouble() } ?: emptyList(),
                    ois = c.get(CameraCharacteristics.LENS_INFO_AVAILABLE_OPTICAL_STABILIZATION)
                        ?.any { it == CameraMetadata.LENS_OPTICAL_STABILIZATION_MODE_ON } ?: false,
                    flash = c.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) ?: false,
                    hardwareLevel = when (c.get(CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)) {
                        CameraMetadata.INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY -> "Legacy"
                        CameraMetadata.INFO_SUPPORTED_HARDWARE_LEVEL_LIMITED -> "Limited"
                        CameraMetadata.INFO_SUPPORTED_HARDWARE_LEVEL_FULL -> "Full"
                        CameraMetadata.INFO_SUPPORTED_HARDWARE_LEVEL_3 -> "Level 3"
                        CameraMetadata.INFO_SUPPORTED_HARDWARE_LEVEL_EXTERNAL -> "External"
                        else -> "Unknown"
                    },
                    raw = caps.contains(CameraMetadata.REQUEST_AVAILABLE_CAPABILITIES_RAW),
                    logicalMulti = caps.contains(CameraMetadata.REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA),
                    maxVideo = maxVideo(id),
                )
            }
        }
    }

    private fun maxVideo(id: String): String? {
        val cam = id.toIntOrNull() ?: return null
        fun has(q: Int) = Sys.safe { CamcorderProfile.hasProfile(cam, q) } == true
        return when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && has(CamcorderProfile.QUALITY_8KUHD) -> "8K"
            has(CamcorderProfile.QUALITY_2160P) -> "4K"
            has(CamcorderProfile.QUALITY_1080P) -> "1080p"
            has(CamcorderProfile.QUALITY_720P) -> "720p"
            has(CamcorderProfile.QUALITY_480P) -> "480p"
            else -> null
        }
    }

    fun sensors(): List<SensorInfo> {
        val sm = ctx.getSystemService(SensorManager::class.java) ?: return emptyList()
        return sm.getSensorList(Sensor.TYPE_ALL).map { s ->
            SensorInfo(
                type = s.type.toLong(),
                typeName = s.stringType?.substringAfterLast("android.sensor.") ?: "",
                name = s.name ?: "",
                vendor = s.vendor ?: "",
                power = s.power.toDouble(),
                maxRange = s.maximumRange.toDouble(),
                resolution = s.resolution.toDouble(),
                minDelayUs = s.minDelay.toLong(),
                wakeUp = s.isWakeUpSensor,
                version = s.version.toLong(),
            )
        }
    }

    fun media(): MediaInfo {
        val codecs = Sys.safe {
            MediaCodecList(MediaCodecList.REGULAR_CODECS).codecInfos.map { c ->
                CodecInfo(
                    name = c.name,
                    encoder = c.isEncoder,
                    types = c.supportedTypes.toList(),
                    hardware = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) c.isHardwareAccelerated else null,
                )
            }
        } ?: emptyList()

        var level: String? = null
        var version: String? = null
        var hdcp: String? = null
        Sys.safe {
            val drm = MediaDrm(WIDEVINE)
            try {
                level = Sys.safe { drm.getPropertyString("securityLevel") }
                version = Sys.safe { drm.getPropertyString(MediaDrm.PROPERTY_VERSION) }
                hdcp = Sys.safe { drm.getPropertyString("maxHdcpLevel") }
            } finally {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) drm.close()
                else @Suppress("DEPRECATION") drm.release()
            }
        }

        val am = ctx.getSystemService(AudioManager::class.java)
        val outputs = Sys.safe {
            am.getDevices(AudioManager.GET_DEVICES_OUTPUTS).mapNotNull { audioDeviceName(it.type) }.distinct()
        } ?: emptyList()
        val pm = ctx.packageManager

        return MediaInfo(
            codecs = codecs,
            widevineLevel = level,
            widevineVersion = version,
            hdcp = hdcp,
            audioOutputs = outputs,
            lowLatency = pm.hasSystemFeature(PackageManager.FEATURE_AUDIO_LOW_LATENCY),
            proAudio = pm.hasSystemFeature(PackageManager.FEATURE_AUDIO_PRO),
            spatial = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S_V2) Sys.safe {
                am.spatializer.immersiveAudioLevel != android.media.Spatializer.SPATIALIZER_IMMERSIVE_LEVEL_NONE
            } else null,
        )
    }

    private fun audioDeviceName(type: Int): String? = when (type) {
        AudioDeviceInfo.TYPE_BUILTIN_SPEAKER -> "Speaker"
        AudioDeviceInfo.TYPE_BUILTIN_EARPIECE -> "Earpiece"
        AudioDeviceInfo.TYPE_WIRED_HEADSET, AudioDeviceInfo.TYPE_WIRED_HEADPHONES -> "Wired headphones"
        AudioDeviceInfo.TYPE_USB_HEADSET, AudioDeviceInfo.TYPE_USB_DEVICE, AudioDeviceInfo.TYPE_USB_ACCESSORY -> "USB audio"
        AudioDeviceInfo.TYPE_BLUETOOTH_A2DP -> "Bluetooth (A2DP)"
        AudioDeviceInfo.TYPE_BLUETOOTH_SCO -> "Bluetooth (calls)"
        AudioDeviceInfo.TYPE_HDMI -> "HDMI"
        AudioDeviceInfo.TYPE_TELEPHONY -> null
        else -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && type == AudioDeviceInfo.TYPE_BLE_HEADSET) "Bluetooth LE Audio" else null
    }

    fun features(): FeaturesInfo {
        val pm = ctx.packageManager
        val adapter = Sys.safe { ctx.getSystemService(BluetoothManager::class.java)?.adapter }
        val wm = ctx.applicationContext.getSystemService(WifiManager::class.java)

        return FeaturesInfo(
            systemFeatures = pm.systemAvailableFeatures.mapNotNull { it.name }.sorted(),
            le2mPhy = adapter?.let { Sys.safe { it.isLe2MPhySupported } },
            leCodedPhy = adapter?.let { Sys.safe { it.isLeCodedPhySupported } },
            leExtendedAdvertising = adapter?.let { Sys.safe { it.isLeExtendedAdvertisingSupported } },
            leAudio = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) adapter?.let {
                Sys.safe { it.isLeAudioSupported == BluetoothStatusCodes.FEATURE_SUPPORTED }
            } else null,
            wifi5Ghz = Sys.safe { wm.is5GHzBandSupported },
            wifi6Ghz = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) Sys.safe { wm.is6GHzBandSupported } else null,
            wifi6 = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Sys.safe { wm.isWifiStandardSupported(ScanResult.WIFI_STANDARD_11AX) }
            } else null,
            wifi7 = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                Sys.safe { wm.isWifiStandardSupported(ScanResult.WIFI_STANDARD_11BE) }
            } else null,
            nfcEnabled = Sys.safe { NfcAdapter.getDefaultAdapter(ctx)?.isEnabled },
        )
    }

    private companion object {
        val WIDEVINE: UUID = UUID.fromString("edef8ba9-79d6-4ace-a3c8-27dcd51d21ed")
    }
}
