
import 'package:flutter/material.dart';
import 'package:marvel_flutter/bloc/ListBloc.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/bloc/ListState.dart';
import 'package:marvel_flutter/model/ComicBook.dart';
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
  final double listPreferredHeight = 250;

  double listPosition = 0;
  double listMinPosition = 0;
  ComicBookListBloc bloc;
  ComicBookList comicBookList;

  AnimationController _controller;
  Animation<double> _animation;

  bool get scrollable => widget.description?.isNotEmpty ?? false;

  double normalized() {
    return listMinPosition > 0 ? listPosition / listMinPosition : 0;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void onScroll(DragUpdateDetails details) {
    if(!_controller.isAnimating && listMinPosition > 0) {
      setState(() {
        listPosition = math.max(0,
            math.min(listMinPosition, listPosition + details.delta.dy));
      });
    }
  }

  void onScrollEnd(DragEndDetails details) {

    double n = normalized();
    bool swipe = details.velocity.pixelsPerSecond.dy.abs() > 1;
    bool down = swipe ? details.velocity.pixelsPerSecond.dy < 0 : n < 0.5;

    double begin = listPosition;
    double end = down ? 0 : listMinPosition;

    _animation = Tween<double>(begin: begin, end: end).animate(_controller)
      ..addListener(() => setState(() => listPosition = _animation.value));

    _controller.forward(from: n);
  }

  @override
  Widget build(BuildContext context) {

    bloc = BlocProvider.of(context);
    if(bloc.currentState.isEmpty) {
      bloc.dispatch(ListEvent());
    }

    return SafeArea(
      minimum: EdgeInsets.all(UiUtils.marginDefault),

      child: GestureDetector(
        onVerticalDragUpdate: scrollable ? onScroll : null,
        onVerticalDragEnd: scrollable ? onScrollEnd : null,

        child: BlocBuilder(
            bloc: bloc,
            builder: (context, ListState<ComicBook> state) {

              if(comicBookList == null && !state.isEmpty) {
                listMinPosition = ComicBookList.calculateHeight(context, listPreferredHeight, coversOnScreen);
                listPosition = listMinPosition;
                comicBookList = ComicBookList(preferredHeight: listPreferredHeight, coversOnScreen: coversOnScreen);
              }

              return Align(
                alignment: Alignment.bottomCenter,

                child: Transform.translate(
                  offset: Offset(0, scrollable ? listPosition : 0),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      //description
                      Opacity(
                        opacity: comicBookList != null ? normalized() : 1,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: UiUtils.marginDefault),
                          child: widget.description?.isNotEmpty ?? false ?
                          ComicTextPanel.white(widget.description) : Container(),
                        ),
                      ),

                      //loading/hit
                      state.isEmpty && state.isLoading ?
                          ComicTextPanel.white('loading comic books') :
                      bloc.currentError != null ?
                          ComicTextPanel.yellow('failed to load') :
                      widget.description?.isNotEmpty ?? false ?
                          Opacity(
                              opacity: normalized(),
                              child: ComicTextPanel.white('Scroll to comic books')) :
                          Container(),

                      Opacity(
                        opacity: scrollable ? 1 - normalized() : 1,
                        child: comicBookList != null ? comicBookList : Container(),
                      )

                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
