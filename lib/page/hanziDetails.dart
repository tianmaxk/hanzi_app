import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer advancedPlayer = new AudioPlayer();

class HanziDetails extends StatelessWidget {
  var wenziInfo = null;

  HanziDetails({Key key, this.wenziInfo}) : super(key: key);

  _playSound(String url){
//    advancedPlayer.setUrl(url);
    advancedPlayer.setVolume(1.0);
    advancedPlayer.play(url);
  }

  @override
  Widget build(BuildContext context) {
    print('$wenziInfo["name"]');
    final double wid = MediaQuery.of(context).size.width-16.0;
    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('汉字'),
        ),
        body: new SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              new Image(
//                image: new NetworkImage(wenziInfo["hanzipic"]),
                image: new NetworkImage('http://www.chaziwang.com/pic/zi/${wenziInfo["unicode"].toUpperCase()}.gif'),
                width: wid??300.0,
                fit: BoxFit.fill,
              ),
              new Row(
                children: <Widget>[
                  new Text("拼音：${wenziInfo["pinyin"]}",style: new TextStyle(fontSize:24.0),),
                  new InkWell(
                    onTap: (){_playSound(wenziInfo["fayin"]);},
                    child: new Icon(Icons.volume_up),
                  )
                ],
              ),
              new Divider(height: 16.0,),
              new Text(wenziInfo["meaning"],style: new TextStyle(fontSize:20.0),),
            ]
          )
        )
    );
  }
}