package com.systemx.app.platform

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.net.Uri
import android.provider.Settings
import io.flutter.plugin.common.EventChannel

/** Implements the Pigeon API by delegating to the probes. */
class DeviceInfoHost(context: Context) : DeviceInfoApi {
    private val ctx = context.applicationContext
    private val system = SystemProbe(ctx)
    private val cpuGpu = CpuGpuProbe(ctx)
    private val hardware = HardwareProbe(ctx)
    private val network = NetworkProbe(ctx)
    private val peripherals = PeripheralProbe(ctx)
    private val liveProbe = LiveProbe(ctx)
    private val appsProbe = AppsProbe(ctx)

    override fun identity() = system.identity()
    override fun system() = system.system()
    override fun cpu() = cpuGpu.cpu()
    override fun gpu() = cpuGpu.gpu()
    override fun memory() = hardware.memory()
    override fun storage() = hardware.storage()
    override fun battery() = hardware.battery()
    override fun display() = hardware.display()
    override fun network() = network.network()
    override fun sim() = network.sim()
    override fun cameras() = peripherals.cameras()
    override fun sensors() = peripherals.sensors()
    override fun media() = peripherals.media()
    override fun features() = peripherals.features()
    override fun security() = system.security()
    override fun live() = liveProbe.live()
    override fun apps() = appsProbe.apps()
    override fun usageAccessGranted() = appsProbe.usageAccessGranted()

    override fun openAppDetails(packageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            .setData(Uri.fromParts("package", packageName, null))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try {
            ctx.startActivity(intent)
        } catch (_: ActivityNotFoundException) {
        }
    }

    override fun openSettings(action: String): Boolean {
        val intent = when (action) {
            "app_details" -> Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(Uri.fromParts("package", ctx.packageName, null))
            else -> Intent(action)
        }.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return try {
            ctx.startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        } catch (_: SecurityException) {
            false
        }
    }

    override fun openLink(url: String): Boolean {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return try {
            ctx.startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }

    override fun dial(code: String) {
        val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + Uri.encode(code)))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try {
            ctx.startActivity(intent)
        } catch (_: ActivityNotFoundException) {
        }
    }
}

/**
 * Streams readings from one sensor. Dart passes the sensor type as the
 * argument; each event is a list of doubles (the sensor's values).
 */
class SensorStreamHandler(context: Context) : EventChannel.StreamHandler, SensorEventListener {
    private val sm = context.applicationContext.getSystemService(SensorManager::class.java)
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val type = (arguments as? Number)?.toInt() ?: return events.endOfStream()
        val sensor = sm?.getDefaultSensor(type) ?: return events.endOfStream()
        sink = events
        sm.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
    }

    override fun onCancel(arguments: Any?) {
        sm?.unregisterListener(this)
        sink = null
    }

    override fun onSensorChanged(event: SensorEvent) {
        sink?.success(event.values.map { it.toDouble() })
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
}
