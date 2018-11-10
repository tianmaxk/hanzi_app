import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import '../common/tts.dart';
import '../common/api.dart';
import 'writeHanzi.dart';

AudioPlayer advancedPlayer = new AudioPlayer();

class HanziDetails extends StatefulWidget {
  var wenziInfo = null;
  var pylist = [];
  HanziDetails({Key key, this.wenziInfo, this.pylist}) : super(key: key);

  @override
  _HanziDetails createState() => new _HanziDetails();
}

class _HanziDetails extends State<HanziDetails> {
  bool isSpeak = false;
  var fayinLst = [];
  List<String> languages;

  _playSound(String url){
    advancedPlayer.setVolume(1.0);
    advancedPlayer.play(url);
  }

  _findHanziByKeywords(String key) async {
    var hanziinfo = await Api().findHanzi(key);
    setState(() {
      try{
        var hz = json.decode(hanziinfo);
        print('hz=$hz');
        widget.wenziInfo = hz["hanzi"];
        fayinLst = hz["pylist"];
      }catch(e){}
    });
  }

  _gotoWriteHanzi() {
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new WriteHanzi(wenziInfo: widget.wenziInfo),
        )
    );
  }

  initPlatformState() async {
    languages = await Tts.getAvailableLanguages();
  }

  String _noReadRedundantWords(String meaning){
    meaning = meaning.replaceAll(new RegExp(r"基本字义\n.*?\n"), "基本字义，\n")
      .replaceAll(new RegExp(r"其他字义\n.*?\n"), "其他字义，\n")
      .replaceAll("、", "，");
    print('_noReadRedundantWords,meaning=$meaning');
    return meaning;
  }

  Widget _getFayinList(){
    if(fayinLst!=null && fayinLst.length>1){
      List<Widget> lst = [];
      lst.add(new Text("拼音：",style: new TextStyle(fontSize:24.0),));
      for(int i=0;i<fayinLst.length;i++){
        lst.add(new InkWell(
            onTap: (){_playSound(fayinLst[i]["fayin"]);},
            child: new Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                new Text(fayinLst[i]["name"],style: new TextStyle(fontSize:24.0),),
                new Icon(Icons.volume_up),
                new Container(width: 10.0,)
              ]),
            )
        );
      }
      return new Wrap(
        direction: Axis.horizontal,
        children: lst,
      );
    } else {
      return new InkWell(
        onTap: (){_playSound(widget.wenziInfo["fayin"]);},
        child: new Row(
          children: <Widget>[
            new Text("拼音：${widget.wenziInfo["pinyin"]}",style: new TextStyle(fontSize:24.0),),
            new Icon(Icons.volume_up),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    String meaning = widget.wenziInfo["meaning"];
    if(meaning==null){
      _findHanziByKeywords(widget.wenziInfo["name"]);
    } else {
      fayinLst = widget.pylist;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('$widget.wenziInfo["name"]');
    String meaning = widget.wenziInfo["meaning"];
    final double wid = MediaQuery.of(context).size.width-16.0;

    Widget fayinWidget = _getFayinList();

    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('汉字'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.brush), onPressed: _gotoWriteHanzi)
          ]
        ),
        body: (meaning==null) ? (new Center(
            child: Image.asset("images/loading.gif",width: 100.0,),
          )) : new SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              new InkWell(
                onTap: (){_gotoWriteHanzi();},
                child: new Stack(
                  children: <Widget>[
                    new Image.asset('images/hanzibg.gif',width: wid??300.0, fit: BoxFit.fill,),
                    new Image(
                      image: new NetworkImage(widget.wenziInfo["hanzipic"]),
//                    image: new NetworkImage('http://www.chaziwang.com/pic/zi/${wenziInfo["unicode"].toUpperCase()}.gif'),
                      width: wid??300.0,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
              new Container(height: 10.0,),
              fayinWidget,
              new Divider(height: 16.0,),
              new InkWell(
                onTap: (){
                    isSpeak = true;
                    Tts.speak(_noReadRedundantWords(meaning));
                },
                child: new Text(meaning,style: new TextStyle(fontSize:20.0),),
              )
            ]
          )
        )
    );
  }

  @override
  void deactivate(){
    if(isSpeak==true){
      Tts.stop();
    }
  }
}