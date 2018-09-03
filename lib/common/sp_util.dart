import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SPUtil {
  static SharedPreferences _prefs;

  static SPUtil _instance;

  static Future<SPUtil> getInstance() async {
    if (_instance == null) {
      await synchronized(_lock, () async {
        if (_instance == null) {
          _instance = new SPUtil._();
          await _instance._init();
        }
      });
    }
    return _instance;
  }

  SPUtil._();

  static Object _lock = new Object();

  _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  getSP() {
    return _prefs;
  }

  // 写入缓存值
  static void setString(String key, String value){
    SPUtil.getInstance().then((spUtil){
      SharedPreferences sp =  spUtil.getSP();
      sp.setString(key, value);
    });
  }

  // 获取缓存值
  static Future<String> getString(String key) async {
    SPUtil spUtil = await SPUtil.getInstance();
    SharedPreferences sp =  spUtil.getSP();
    return sp.getString(key);
  }

  // 获得SharedPreferences
  static Future<SharedPreferences> getSharedPreferences() async {
    SPUtil spUtil = await SPUtil.getInstance();
    return spUtil.getSP();
  }
}


//SPUtil.getInstance().then((spUtil){
//SharedPreferences sp =  spUtil.getSP();
//});
