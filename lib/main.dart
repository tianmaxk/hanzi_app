import 'package:flutter/material.dart';
import 'mainPage.dart';
import 'page/findHanzi.dart';
import 'common/deviceInfo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  _getDeviceInfo() async {
    Map<String, dynamic> devinfo = await DeviceInfo.getDeviceInfo();
    print('devinfo=$devinfo');
  }

  @override
  Widget build(BuildContext context) {
    _getDeviceInfo();
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new MainPage(),
        '/findhanzi': (BuildContext context) => new FindHanzi(),
      },
    );
  }
}