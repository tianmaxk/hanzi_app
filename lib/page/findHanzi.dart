import 'package:flutter/material.dart';
import 'dart:convert';
import '../common/api.dart';
import 'hanziDetails.dart';

class FindHanzi extends StatelessWidget {
  FindHanzi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('查汉字'),
          //为AppBar对象的actions属性添加一个IconButton对象，actions属性值可以是Widget类型的数组
//          actions: <Widget>[
//            new IconButton(icon: isFavor?new Icon(Icons.favorite):new Icon(Icons.favorite_border), onPressed: _onFavor),
//            new IconButton(icon: new Icon(Icons.web), onPressed: _gotoWeb)
//          ],
        ),
        body: new FindHanziPage()
    );
  }
}

class FindHanziPage extends StatefulWidget {
  FindHanziPage({Key key}) : super(key: key);

  @override
  _FindHanziPage createState() => new _FindHanziPage();
}

class _FindHanziPage extends State<FindHanziPage> {
  String keywords = "";
  var hanzi = null;
  var pylist = [];
  bool busy = false;
  TextEditingController _controller = new TextEditingController.fromValue(new TextEditingValue(text: ""));

  _findHanziByKeywords(String key) async {
    var hanziinfo = await Api().findHanzi(key);
    setState(() {
      busy = false;
      try{
        var hz = json.decode(hanziinfo);
        hanzi = hz["hanzi"];
        pylist = hz["pylist"];
      }catch(e){}
    });
  }

  _gotoWenziDtl(var wenzi,var pylist){
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new HanziDetails(wenziInfo: wenzi,pylist:pylist),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: new Material(
            borderRadius: BorderRadius.circular(14.0),
//            shadowColor: Colors.blue.shade200,
//            elevation: 5.0,
            child: TextField(
                enabled: !busy,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "在此输入汉字",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black12,
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
                onChanged: (String value){
                  setState(() {
                    busy = true;
                    hanzi = null;
                    keywords = value.substring(value.length-1);
                    _controller.value = new TextEditingValue(text: keywords);
                    _findHanziByKeywords(keywords);
                  });
                },
                controller: _controller,
            ),
          ),
        ),
        Container(
          child: hanzi==null?Container():new InkWell(
            onTap: () {_gotoWenziDtl(hanzi,pylist);},
            child: new Image(
              image: new NetworkImage(hanzi["hanzipic"]),
              fit: BoxFit.cover,
            ),
          ),
        ),

      ],
    );
  }
}