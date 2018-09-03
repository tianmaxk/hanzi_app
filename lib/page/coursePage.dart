import 'package:flutter/material.dart';
import '../common/file_util.dart';
import 'hanziDetails.dart';

class CoursePage extends StatefulWidget {
  CoursePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CoursePage();
}

class _CoursePage extends State<CoursePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var _wenziList = [];
  String courseInfo = "";

  _getCourse() async {
    courseInfo = await FileUtil.loadAssetString("assets/course.txt");
    setState(() {
      for(int i=0;i<courseInfo.length;i++){
        var obj = {};
        obj['name'] = courseInfo[i];
        obj['unicode'] = courseInfo.codeUnitAt(i).toRadixString(16);
        _wenziList.add(obj);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCourse();
  }

  @override
  Widget build(BuildContext context) {
    if(_wenziList.length<=0){
      return Center(
        child: Image.asset("images/loading.gif",width: 100.0,),
      );
    } else {
      return new GridView.count(
          primary: false,
          padding: const EdgeInsets.all(8.0),
          mainAxisSpacing: 8.0,
          //竖向间距
          crossAxisCount: 3,
          //横向Item的个数
          crossAxisSpacing: 8.0,
          //横向间距
          children: buildGridTileList(_wenziList.length)
      );
    }
  }

  List<Widget> buildGridTileList(int number) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < number; i++) {
      widgetList.add(getItemWidget(_wenziList[i]));
    }
    return widgetList;
  }

  _gotoWenziDtl(var wenzi){
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new HanziDetails(wenziInfo: wenzi),
        )
    );
  }

  Widget getItemWidget(var wenzi) {
    //BoxFit 可设置展示图片时 的填充方式
    return new InkWell(
      onTap: () {_gotoWenziDtl(wenzi);},
      child: new Image(
        image: new NetworkImage('http://www.chaziwang.com/pic/zi/${wenzi["unicode"].toUpperCase()}.gif'),
        fit: BoxFit.cover,
      ),
    );
  }
}