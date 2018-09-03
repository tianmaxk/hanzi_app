import 'dart:async';

import 'package:flutter/services.dart';

class PhoneInfo {
  static const MethodChannel _channel =
  const MethodChannel('ptp.flutter.com/phoneinfo');

  static Future<dynamic> getIMEI () => _channel.invokeMethod('getIMEI');
  static Future<dynamic> getIMSI () => _channel.invokeMethod('getIMSI');
}