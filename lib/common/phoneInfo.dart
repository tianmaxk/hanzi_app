import 'dart:async';

import 'package:flutter/services.dart';

class PhoneInfo {
  static const MethodChannel _channel =
  const MethodChannel('ptp.flutter.io/phoneinfo');

  static Future<String> getIMEI () => _channel.invokeMethod('getIMEI');
  static Future<String> getIMSI () => _channel.invokeMethod('getIMSI');

}