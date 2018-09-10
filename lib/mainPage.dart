import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'page/homeHanzi.dart';
import 'page/coursePage.dart';
import 'page/pinyinPage.dart';
import 'page/examinePage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['查字', '课程', '拼音', '考试'];
  var _pageController = new PageController(initialPage: 0);
  bool needAll = false;

  /*
   * 根据image路径获取图片
   * 这个图片的路径需要在 pubspec.yaml 中去定义
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  /*
   * 根据索引获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(color: const Color(0xff63ca6c)));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(color: const Color(0xff888888)));
    }
  }

  /*
   * 存储的四个页面，和Fragment一样
   */
  var _bodys;

  void initData() {
    /*
      bottom的按压图片
     */
    tabImages = [
      [
        getTabImage('images/home.png'),
        getTabImage('images/home.png')
      ],
      [
        getTabImage('images/eye.png'),
        getTabImage('images/eye.png')
      ],
      [
        getTabImage('images/pinyinchar.png'),
        getTabImage('images/pinyinchar.png')
      ],
      [
        getTabImage('images/examine.png'),
        getTabImage('images/examine.png')
      ]
    ];

    _bodys = [
      new HomeHanzi(needAll:needAll),
      new CoursePage(),
      new PinyinPage(),
      new ExaminePage()
    ];
  }

  void _pageChange(int index){
    setState(() {
      if(_tabIndex!=index){
        _tabIndex = index;
        _pageController.jumpToPage(index);
      }
    });
  }

  void _handlePopupMenu(BuildContext context, String value){
    setState(() {
      needAll = (value=='all');
    });
  }

  void _onSearch(){
    Navigator.pushNamed(context, "/findhanzi");
  }

  dynamic buildAction(int index){
    if(index==0){
      return <Widget>[
        new IconButton(icon: new Icon(Icons.search), onPressed: _onSearch),
        new PopupMenuButton<String>(
          onSelected: (String value) { _handlePopupMenu(context, value); },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
              value: 'chang',
              child: Text('常用字',
                style: TextStyle(
                  color: needAll?Colors.grey:Colors.blue,
                ),
              ),
            ),
            new PopupMenuItem<String>(
              value: 'all',
              child: Text('所有字',
                style: TextStyle(
                  color: needAll?Colors.blue:Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ];
    }
    return <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return Scaffold(
      appBar: new AppBar(
        title: new Text(appBarTitles[_tabIndex]),
        actions: buildAction(_tabIndex),
      ),
      body: _bodys[_tabIndex],
      //如下的PageView是帮助实现滑动效果的
//      body: new PageView.builder(
//          onPageChanged: _pageChange,
//          controller: _pageController,
//          itemBuilder: (BuildContext context,int index){
//            if(index>=0 && index<_bodys.length){
//              return _bodys[index];
//            }
//          },
//          itemCount: _bodys.length,
//      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: getTabIcon(0), title: getTabTitle(0)),
          new BottomNavigationBarItem(
              icon: getTabIcon(1), title: getTabTitle(1)),
          new BottomNavigationBarItem(
              icon: getTabIcon(2), title: getTabTitle(2)),
          new BottomNavigationBarItem(
              icon: getTabIcon(3), title: getTabTitle(3)),
        ],
        //设置显示的模式
        type: BottomNavigationBarType.fixed,
        //设置当前的索引
        currentIndex: _tabIndex,
        //tabBottom的点击监听
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
    //如下是实现滑动切换效果的
//        onTap: (int index) {
//          _pageChange(index);
//        },
      ),
    );
  }
}