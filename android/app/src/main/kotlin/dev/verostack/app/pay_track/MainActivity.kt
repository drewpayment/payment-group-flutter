package dev.verostack.app.pay_track

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, "andriod_app_retain").apply {
      setMethodCallHandler { method, result -> 
        if (method.method == "sendToBackground") {
          moveTaskToBack(true)
        }
      }
    }
  }
}
