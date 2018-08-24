import 'package:flutter/material.dart';

class ExaminePage extends StatefulWidget {
  ExaminePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ExaminePage();
}

class _ExaminePage extends State<ExaminePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    return Center(child: Text("考试"),);
  }
}