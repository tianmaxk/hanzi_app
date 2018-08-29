import 'package:flutter/material.dart';
import 'dart:async';

class ProgressBar extends StatefulWidget {
  int count;
  int milliseconds;
  Color color;
  Size size;

  ProgressBar({Key key, int count:5, int milliseconds:400, Color color:Colors.green, Size size}):super(key: key){
    this.count = count;
    this.milliseconds = milliseconds;
    this.color = color;
    this.size = size;
  }

  @override
  _ProgressState createState() => new _ProgressState();
}

class _ProgressState extends State<ProgressBar> with TickerProviderStateMixin {

  List<Animation<double>>animators = [];
  List<AnimationController>_animationControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.count; i++) {
      var animationController = new AnimationController(vsync: this,
          duration: Duration(milliseconds: widget.milliseconds * widget.count));
      animationController.value=0.8*i/widget.count;
      _animationControllers.add(animationController);
      Animation<double> animation = new Tween(begin: 0.1, end: 1.9).animate(
          animationController);
      animators.add(animation);
    }
    animators[0].addListener(_change);
    try {
      var mi = (widget.milliseconds~/(animators.length-1));
      for (int i = 0; i < animators.length; i++) {
        print(( mi*i).toString());
        dodelay(_animationControllers[i], mi*i);
      }
    } on Exception {

    }
  }

  void dodelay(AnimationController _animationControllers,
      int delay) async{
    Future.delayed(Duration(milliseconds: delay),(){
      _animationControllers..repeat().orCancel;
    });
  }

  void _change() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(painter: _Progress(
        animators: animators, color: widget.color, count: widget.count),
      size: widget.size,);
  }

  @override
  void deactivate(){
    animators[0].removeListener(_change);
  }

  @override
  void dispose() {
    super.dispose();
    try{
      animators[0].removeListener(_change);
    } on Exception {}
    try{
      for (AnimationController _animationController in _animationControllers) {
        _animationController.dispose();
      }
    } on Exception {}
  }
}

class _Progress extends CustomPainter {
  final Color color;
  final int count;
  final List<Animation<double>>animators;

  const _Progress({this.animators, this.color, this.count});

  @override
  void paint(Canvas canvas, Size size) {
    var radius = size.width / (3 * count + 1);
    var paint = new Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (int i = 1; i < count + 1; i++) {
      double value = animators[i - 1].value;
      canvas.drawCircle(
          new Offset(radius * i * 3 - radius, size.height / 2),
          radius * (value > 1 ? (2 - value) : value), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}