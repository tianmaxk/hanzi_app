import 'package:flutter/material.dart';
import 'dart:convert';
import '../common/api.dart';
import '../common/file_util.dart';
import 'hanziDetails.dart';

const String wenziListCachePath = "wenziListCache";
const int wenzipagesize = 15;

class HomeHanzi extends StatefulWidget {
  bool needAll = false;
  HomeHanzi({Key key,this.needAll}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePage();
}

class _HomePage extends State<HomeHanzi> with AutomaticKeepAliveClientMixin {
  var _wenziList = [];
  int pageno = 1;
  bool busy = false;
  bool oriNeedAll = false;

  @override
  bool get wantKeepAlive => true;

  _saveCache(var list){
    var info = [];
    for(var i=0;i<list.length;i++){
      var ln = {};
      ln['name'] = list[i]['name'];
      ln['unicode'] = list[i]['unicode'];
      info.add(ln);
    }
    String cache = json.encode(info);
    FileUtil.writeFileAsString(wenziListCachePath, cache);
  }

  _getFromCacheThenFromList() async{
    String info = await FileUtil.readFileAsString(wenziListCachePath);
    if(info!=null && info.isNotEmpty){
      var hanzilist = json.decode(info);
      if(hanzilist!=null && hanzilist.length>0) {
        setState(() {
          pageno = (hanzilist.length/15).toInt();
          print('pageno=$pageno');
          _wenziList.addAll(hanzilist);
          print('_wenziList from cache=$_wenziList');
        });
        return;
      }
    }
    pageno = 1;
    _getHanziList();
  }

  _getHanziList({int pagesize:wenzipagesize}) async {
    var hanziinfo = await Api().getHanziList(page:pageno, pagesize:pagesize, needAll:widget.needAll);
    busy = false;
    var hanzilist = json.decode(hanziinfo)['list'];
    setState(() {
      if(hanzilist!=null) {
        _wenziList.addAll(hanzilist);
      }
      print('_wenziList=$_wenziList');
      _saveCache(_wenziList);
    });
  }

  @override
  void initState() {
    super.initState();
    if(_wenziList.length<=0){
      pageno = 1;
      _getFromCacheThenFromList();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('oriNeedAll=${oriNeedAll}, needAll=${widget.needAll}');
    if(oriNeedAll != widget.needAll){
      oriNeedAll = widget.needAll;
      setState(() {
        FileUtil.deleteFile(wenziListCachePath);
        _wenziList.clear();
      });
      pageno = 1;
      _getHanziList();
    }
    if(_wenziList.length<=0){
      return Center(
        child: Image.asset("images/loading.gif",width: 100.0,),
      );
    } else {
      Widget bodyWid = new RefreshIndicator(
        child: new NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: new GridView.count(
              primary: false,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 8.0,
              //竖向间距
              crossAxisCount: 3,
              //横向Item的个数
              crossAxisSpacing: 8.0,
              //横向间距
              children: buildGridTileList(_wenziList.length)
          ),
        ),
        onRefresh: () async {
          setState(() {
            FileUtil.deleteFile(wenziListCachePath);
            _wenziList.clear();
          });
          pageno = 1;
          _getHanziList();
          return null;
        },
      );
        //这是背景效果，目前不需要这个效果
//      return new ShaderMask(
//        shaderCallback: (Rect bounds) {
//          return new RadialGradient(
//            center: Alignment.topLeft,
//            radius: 1.0,
//            colors: <Color>[Colors.yellow, Colors.deepOrange.shade900],
//            tileMode: TileMode.mirror,
//          ).createShader(bounds);
//        },
//        child: bodyWid,
//      );
      return new Stack(children: <Widget>[
        bodyWid,
        busy?new Opacity(opacity: 0.5,child: new Container(color: Colors.grey,),):new Container()
      ],);
    }
  }

  bool _handleScrollNotification(ScrollNotification notification){
    //ScrollUpdateNotification 还有其他可使用，需要自行优化
    if(notification is ScrollEndNotification){
      print('notification.metrics.extentAfter=${notification.metrics.extentAfter}');
      //下滑到最底部
      if(notification.metrics.extentAfter==0.0){
        if(!busy) {
          setState(() {
            busy = true;
            pageno++;
            _getHanziList();
          });
        }
      }
      //滑动到最顶部
      if(notification.metrics.extentBefore==0.0){

      }
    }
    return false;
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