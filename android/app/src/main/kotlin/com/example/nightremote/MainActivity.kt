package com.example.nightremote

import android.view.KeyEvent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "volume"
    private var manager: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        manager = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL);
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            manager?.invokeMethod("volume", "-");
        }
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            manager?.invokeMethod("volume", "+");
        }
        return super.onKeyDown(keyCode, event)
    }
}
