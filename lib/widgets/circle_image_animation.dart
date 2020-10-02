import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
class CircleImageAnimation extends StatefulWidget {
  CircleImageAnimation({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _CircleImageAnimationState createState() => _CircleImageAnimationState();
}

class _CircleImageAnimationState extends State<CircleImageAnimation>
    with TickerProviderStateMixin {
  AnimationController _musiccontroller;

  @override
  void initState() {
    super.initState();
    _musiccontroller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );
    _musiccontroller.repeat();


  }

  @override
  void dispose() {
    _musiccontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: new AnimatedBuilder(
        animation: _musiccontroller,
        child: new Container(
          height: 60.0,
          width: 60.0,
          child: widget.child,
        ),
        builder: (BuildContext context, Widget _widget) {
          return new Transform.rotate(
            angle: _musiccontroller.value * 6.3,
            child: _widget
          );
        },
      ),
    );
  }
}
