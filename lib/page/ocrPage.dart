import 'package:flutter/material.dart';

class OCRPage extends StatefulWidget {
  OCRPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _OCRPage();
}

class _OCRPage extends State<OCRPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    return Center(child: Text("识字"),);
  }
}