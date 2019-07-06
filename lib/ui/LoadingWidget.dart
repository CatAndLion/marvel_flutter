
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

class LoadingWidget extends StatefulWidget {

  final String _message;

  LoadingWidget(this._message);

  @override
  State createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat();

    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _controller,
      child: Text(widget._message,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Ace',
          fontSize: 20,
        ),
      ),
      builder: (context, widget) {
        return Opacity(
          opacity: _controller.value,
          child: widget,
        );
      },
    );
  }

}
