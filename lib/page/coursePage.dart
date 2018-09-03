import 'package:flutter/material.dart';
import '../common/file_util.dart';

class CoursePage extends StatefulWidget {
  CoursePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CoursePage();
}

class _CoursePage extends State<CoursePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String courseInfo = "正在加载";

  _getCourse() async {
    String retInfo = await FileUtil.loadAssetString("assets/course.txt");
    setState(() {
      courseInfo = retInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCourse();
  }

  @override
  Widget build(BuildContext context) {

    return Center(child: Text(courseInfo),);
  }
}