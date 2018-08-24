import 'package:flutter/material.dart';

class MemoryPage extends StatefulWidget {
  MemoryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MemoryPage();
}

class _MemoryPage extends State<MemoryPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    return Center(child: Text("记忆"),);
  }
}