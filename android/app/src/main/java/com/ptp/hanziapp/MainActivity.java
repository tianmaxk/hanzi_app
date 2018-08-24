package com.ptp.hanziapp;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String TTSCHANNEL = "ptp.flutter.io/tts";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), TTSCHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                Tts tts = new Tts(MainActivity.this);
                if (call.method.equals("speak")) {
                  String text = call.argument("text");
                  tts.speak(text);
                } else if (call.method.equals("isLanguageAvailable")) {
                  String language = call.argument("language");
                  final Boolean isAvailable = tts.isLanguageAvailable(language);
                  result.success(isAvailable);
                } else if (call.method.equals("setLanguage")) {
                  String language = call.argument("language");
                  final Boolean success = tts.setLanguage(language);
                  result.success(success);
                } else if (call.method.equals("getAvailableLanguages")) {
                  result.success(tts.getAvailableLanguages());
                } else if (call.method.equals("stop")) {
                  tts.stop();
                }
                else {
                  result.notImplemented();
                }
              }
            }
    );
  }
}