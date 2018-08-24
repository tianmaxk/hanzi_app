import 'dart:async';

import 'package:flutter/services.dart';

class Tts {
  static const MethodChannel _channel =
  const MethodChannel('ptp.flutter.io/tts');

  static Future<bool> isLanguageAvailable (String language) => _channel.invokeMethod('isLanguageAvailable', <String, Object>{
    'language': language});

  static Future<bool> setLanguage (String language) => _channel.invokeMethod('setLanguage', <String, Object>{
    'language': language});

  static Future<List<String>> getAvailableLanguages () => _channel.invokeMethod('getAvailableLanguages');

  static void speak (String text) => _channel.invokeMethod('speak', <String, Object>{
    'text': text});

  static void stop () => _channel.invokeMethod('stop');
}
