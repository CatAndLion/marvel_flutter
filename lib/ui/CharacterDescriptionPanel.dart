
import 'package:flutter/material.dart';
import 'package:marvel_flutter/bloc/CharacterListBlock.dart';
import 'package:marvel_flutter/ui/ComicBookList.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_flutter/ui/ComicTextPanel.dart';
import 'package:marvel_flutter/util/UiUtils.dart';
import 'dart:math' as math;

class CharacterDescriptionPanel extends StatefulWidget {

  final String description;

  CharacterDescriptionPanel(this.description);

  @override
  _CharacterDescriptionPanelState createState() => _CharacterDescriptionPanelState();
}

class _CharacterDescriptionPanelState extends State<CharacterDescriptionPanel> with TickerProviderStateMixin {

  final int coversOnScreen = 2;

  double listPosition = 0;
  ComicBookListBloc bloc;
  ComicBookList comicBookList;

  AnimationController _controller;
  Animation<double> _animation;

  double get height => comicBookList.height > 0 ? comicBookList.height : 0;

  double normalize(double x) {
    return height > 0 ? x / height : 0;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void onScroll(DragUpdateDetails details) {
    if(!_controller.isAnimating && height > 0) {
      setState(() {
        listPosition = math.max(0,
            math.min(height, listPosition + details.delta.dy));
      });
    }
  }

  void onScrollEnd(DragEndDetails details) {

    double n = normalize(listPosition);
    bool swipe = details.velocity.pixelsPerSecond.dy.abs() > 1;
    bool down = swipe ? details.velocity.pixelsPerSecond.dy < 0 : n < 0.5;

    double begin = listPosition;
    double end = down ? 0 : height;

    _animation = Tween<double>(begin: begin, end: end).animate(_controller)
      ..addListener(() => setState(() => listPosition = _animation.value));

    _controller.forward(from: n);
  }

  @override
  Widget build(BuildContext context) {

    bloc = BlocProvider.of(context);
    if(comicBookList == null) {
      comicBookList = ComicBookList(MediaQuery.of(context).size.width - UiUtils.marginDefault, coversOnScreen);
      listPosition = comicBookList.height;
    }

    return Transform.translate(
      offset: Offset(0, listPosition),
      child: GestureDetector(

        onVerticalDragUpdate: onScroll,
        onVerticalDragEnd: onScrollEnd,

        child: SafeArea(
          minimum: EdgeInsets.all(UiUtils.marginDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Opacity(
                opacity: normalize(listPosition),
                child: Padding(
                  padding: EdgeInsets.only(bottom: UiUtils.marginDefault),
                  child: widget.description?.isNotEmpty ?? false ?
                  ComicTextPanel.white(widget.description) : Container(),
                ),
              ),

              Opacity(
                opacity: 1 - normalize(listPosition),
                child: comicBookList
              ),

            ],
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
