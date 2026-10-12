package com.systemx.app

import android.content.Intent
import android.view.KeyEvent
import com.systemx.app.background.BackgroundBridge
import com.systemx.app.platform.BackgroundApi
import com.systemx.app.platform.BackgroundHost
import com.systemx.app.platform.DeviceInfoApi
import com.systemx.app.platform.DeviceInfoHost
import com.systemx.app.platform.GnssStreamHandler
import com.systemx.app.platform.HardwareTestApi
import com.systemx.app.platform.HardwareTestHost
import com.systemx.app.platform.PermissionApi
import com.systemx.app.platform.PermissionHost
import com.systemx.app.platform.PlayApi
import com.systemx.app.platform.PlayHost
import com.systemx.app.platform.SensorStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private lateinit var permissions: PermissionHost
    private lateinit var hardware: HardwareTestHost

    /** Set while the volume button tests listen; presses go to Flutter, not the volume. */
    private var volumeSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        permissions = PermissionHost(this)
        hardware = HardwareTestHost(this)
        HardwareTestApi.setUp(messenger, hardware)
        EventChannel(messenger, "systemx/gnss").setStreamHandler(GnssStreamHandler(this))
        EventChannel(messenger, "systemx/volume_keys").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                volumeSink = events
            }

            override fun onCancel(arguments: Any?) {
                volumeSink = null
            }
        })
        BackgroundApi.setUp(messenger, BackgroundHost(this))
        PlayApi.setUp(messenger, PlayHost(this))
        BackgroundBridge.onAppStart(this)
        DeviceInfoApi.setUp(messenger, DeviceInfoHost(this))
        PermissionApi.setUp(messenger, permissions)
        EventChannel(messenger, "systemx/sensor").setStreamHandler(SensorStreamHandler(this))
    }

    // Volume keys are handled by the system before Flutter sees them, so the
    // volume button tests capture them here while they listen.
    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        val sink = volumeSink
        val key = event.keyCode
        if (sink != null && (key == KeyEvent.KEYCODE_VOLUME_UP || key == KeyEvent.KEYCODE_VOLUME_DOWN)) {
            if (event.action == KeyEvent.ACTION_DOWN && event.repeatCount == 0) {
                sink.success(if (key == KeyEvent.KEYCODE_VOLUME_UP) "up" else "down")
            }
            return true
        }
        return super.dispatchKeyEvent(event)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        this.permissions.onResult(requestCode)
    }

    @Deprecated("FlutterActivity still delivers results here")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (::hardware.isInitialized && hardware.onActivityResult(requestCode, resultCode, data)) return
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
    }
}
