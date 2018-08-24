import 'package:flutter/material.dart';
import 'dart:convert';
import '../common/api.dart';
import 'hanziDetails.dart';

class HomePage extends StatefulWidget {
  bool needAll = false;
  HomePage({Key key,this.needAll}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePage();
//  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin {
  var _wenziList = [];
  int pageno = 1;
  bool busy = false;
  bool oriNeedAll = false;

  @override
  bool get wantKeepAlive => true;

  _getHanziList({int pagesize:15}) async {
    var hanziinfo = await Api().getHanziList(page:pageno, pagesize:pagesize, needAll:widget.needAll);
    busy = false;
    var hanzilist = json.decode(hanziinfo)['list'];
    setState(() {
      if(hanzilist!=null) {
        _wenziList.addAll(hanzilist);
      }
      print('_wenziList=$_wenziList');
    });
  }

  @override
  void initState() {
    super.initState();
    if(_wenziList.length<=0){
      pageno = 1;
      _getHanziList();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('oriNeedAll=${oriNeedAll}, needAll=${widget.needAll}');
    if(oriNeedAll != widget.needAll){
      oriNeedAll = widget.needAll;
      setState(() {
        _wenziList.clear();
      });
      pageno = 1;
      _getHanziList();
    }
    return new RefreshIndicator(
      child: new NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: new GridView.count(
                primary: false,
                padding: const EdgeInsets.all(8.0),
                mainAxisSpacing: 8.0,//竖向间距
                crossAxisCount: 3,//横向Item的个数
                crossAxisSpacing: 8.0,//横向间距
                children: buildGridTileList(_wenziList.length)
            ),
      ),
      onRefresh: () async {
        setState(() {
          _wenziList.clear();
        });
        pageno = 1;
        _getHanziList();
        return null;
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification){
    //ScrollUpdateNotification 还有其他可使用，需要自行优化
    if(notification is ScrollEndNotification){
      print('notification.metrics.extentAfter=${notification.metrics.extentAfter}');
      //下滑到最底部
      if(notification.metrics.extentAfter==0.0){
        if(!busy){
          busy = true;
          pageno++;
          _getHanziList();
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
          image: new NetworkImage(wenzi["hanzipic"]),
//          image: new NetworkImage('http://www.chaziwang.com/pic/zi/${wenzi["unicode"].toUpperCase()}.gif'),
          fit: BoxFit.cover,
        ),
      );
  }
}