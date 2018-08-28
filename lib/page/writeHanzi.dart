import 'package:flutter/material.dart';
import 'package:painter/painter.dart';

class WriteHanzi extends StatefulWidget {
  var wenziInfo = null;
  WriteHanzi({Key key, this.wenziInfo}) : super(key: key);

  @override
  _WriteHanziPage createState() => new _WriteHanziPage();
}

class _WriteHanziPage extends State<WriteHanzi> {
  PainterController _controller;
  bool showHanziOutter = false;

  PainterController _newController(){
    PainterController controller=new PainterController();
    controller.thickness=20.0;
    controller.drawColor=Colors.green;
    controller.backgroundColor=Colors.transparent;
    return controller;
  }

  _changeMode(){
    setState(() {
      showHanziOutter = !showHanziOutter;
      print('showHanziOutter=$showHanziOutter');
    });
  }

  @override
  void initState() {
    super.initState();
    _controller=_newController();
  }

  @override
  Widget build(BuildContext context) {
    final double wid = MediaQuery.of(context).size.width-16.0;
    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('练字'),
          //为AppBar对象的actions属性添加一个IconButton对象，actions属性值可以是Widget类型的数组
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.delete),tooltip: 'Clear',onPressed: _controller.clear),
            new IconButton(icon: new Icon(showHanziOutter?Icons.person_outline:Icons.aspect_ratio), onPressed: _changeMode)
          ],
        ),
        body: new Container(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Stack(
                    children: <Widget>[
                      new Image.asset('images/hanzibg.gif',width: 120.0, fit: BoxFit.fill,),
                      new Image(
                        image: new NetworkImage(widget.wenziInfo["hanzipic"]),
                        width: 120.0,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  new Divider(height: 20.0,),
                  new Container(
                      child: new Center(
                        child: new AspectRatio(
                            aspectRatio: 1.0,
//                            child: new Painter( _controller)
                            child: new Stack(
                              children: <Widget>[
                                new Image.asset('images/hanzibg.gif',width: wid, fit: BoxFit.fill,),
                                showHanziOutter?(new Image(
                                  image: new NetworkImage(widget.wenziInfo["hanzipic"]),
                                  width: wid,
                                  fit: BoxFit.fill,
                                )):new Container(),
                                new Painter( _controller),
                              ],
                            ),
                        )
                      )
                  )
                ]
            )
        )
    );
  }
}