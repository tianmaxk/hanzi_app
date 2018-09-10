import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import '../common/file_util.dart';

AudioPlayer advancedPlayer = new AudioPlayer();

class PinyinPage extends StatefulWidget {
  PinyinPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PinyinPage();
}

class _PinyinPage extends State<PinyinPage> with AutomaticKeepAliveClientMixin {
  var pinyinbiao = null;
  String activeBtn = "";

  @override
  bool get wantKeepAlive => true;

  void _getPinyinInfo() async {
    String pyinfo = await FileUtil.loadAssetString("assets/pinyin.json");
    setState(() {
      pinyinbiao = json.decode(pyinfo);
    });
  }

  @override
  void initState(){
    _getPinyinInfo();
  }

  Widget pybtn(String text,String param){
    return (activeBtn==param || activeBtn=='') ? new Row(
        children: <Widget>[
          new Expanded(
            child: activeBtn==param ? new RaisedButton(
              color: Theme.of(context).primaryColor,
              child: new Text(text,style: new TextStyle(color: Colors.white,fontSize: 18.0)),
              onPressed: (){
                _pressCb(param);
              },
            ) : new OutlineButton(
              borderSide:new BorderSide(color: Theme.of(context).primaryColor),
              child: new Text(text,style: new TextStyle(color: Theme.of(context).primaryColor,fontSize: 18.0)),
              onPressed: (){
                _pressCb(param);
              },
            )
          )
        ]
    ) : new Container();
  }

  Widget pyContent(String type, {bool sd: false}){
    return activeBtn==type?
        new Flexible(
          child: new GridView.count(
              primary: false,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 8.0,
              //竖向间距
              crossAxisCount: sd?4:3,
              //横向Item的个数
              crossAxisSpacing: 4.0,
              //横向间距
              children: buildGridTileList(pinyinbiao[type],sd:sd)
          ),
        ) : new Container();
  }

  List<Widget> buildGridTileList(var pyLst, {bool sd: false}) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < pyLst.length; i++) {
      widgetList.add(getItemWidget(pyLst[i], sd:sd));
    }
    return widgetList;
  }

  _playSound(String url){
    advancedPlayer.setVolume(1.0);
    advancedPlayer.play("http://du.hanyupinyin.cn/du/${url}.mp3");
  }

  Widget getItemWidget(var py, {bool sd: false}) {
    String txt = py["c"];
    double ftsize = sd?(txt.length>=3?(txt.length>=4?35.0:40.0):50.0):(txt.length>3?45.0:50.0);
    //BoxFit 可设置展示图片时 的填充方式
    return new InkWell(
      onTap: () {_playSound(py["url"]);},
      child: new Center(
        child:new Text(txt,style: new TextStyle(color: Colors.black, fontSize: ftsize, fontWeight: FontWeight.bold),)
      ),
    );
  }

  void _pressCb(String param){
    print('param=$param');
    setState(() {
      activeBtn = activeBtn==param?"":param;
    });
  }

  @override
  Widget build(BuildContext context) {

    return (pinyinbiao==null) ? (new Center(
      child: Image.asset("images/loading.gif",width: 100.0,),
    )) :
    new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            pybtn("韵母表","yunmu"),
            pyContent("yunmu"),
            pybtn("生母表","shengmu"),
            pyContent("shengmu"),
            pybtn("整体认读音节","zhengti"),
            pyContent("zhengti"),
            pybtn("单韵母声调","danyunmu"),
            pyContent("danyunmu",sd:true),
            pybtn("复韵母声调","fuyunmu"),
            pyContent("fuyunmu",sd:true),
            pybtn("鼻韵母","biyunmu"),
            pyContent("biyunmu",sd:true),
            pybtn("整体认读音节声调","zhengtisd"),
            pyContent("zhengtisd",sd:true),
          ]
        ),
    );
  }
}