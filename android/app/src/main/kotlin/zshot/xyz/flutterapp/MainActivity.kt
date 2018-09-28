package zshot.xyz.flutterapp

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity(): FlutterActivity() {

    private val EVENT_CHANNEL = "com.shanbay.shared.data/event"
    private val METHOD_CHANNEL = "com.shanbay.shared.data/method"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
//    val mChannel = EventChannel(flutterView,EVENT_CHANNEL)
//
//    mChannel.setStreamHandler(
//            object : EventChannel.StreamHandler {
//              override fun onListen(o: Any, sink: EventChannel.EventSink) {
//                sink.success("refresh")
//              }
//
//              override fun onCancel(o: Any) {
//
//              }
//            }
//    )
      val mMethodChannel = MethodChannel(flutterView, METHOD_CHANNEL)
      mMethodChannel.setMethodCallHandler(
              object : MethodChannel.MethodCallHandler {
                  override fun onMethodCall(call: MethodCall?, result: MethodChannel.Result?) {

                      if (call?.method.equals("getProfileJson")) {
                          result?.success("123")

                      }
                  }
              }
      )
  }
}
