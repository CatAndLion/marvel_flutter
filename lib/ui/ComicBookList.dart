import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_flutter/bloc/ListBloc.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/ui/ComicBookPanel.dart';
import 'package:marvel_flutter/util/UiUtils.dart';
import 'dart:math' as math;

class ComicBookList extends StatefulWidget {

  double _width, _height, _padding;
  final double preferredHeight;
  final int coversOnScreen;

  double get height => _height;
  double get width => _width;

  ComicBookList({ double preferredHeight, int coversOnScreen }) :
      preferredHeight = math.max(0, preferredHeight),
      coversOnScreen = math.max(1, coversOnScreen) {
    _width =_height = _padding = 0;
  }

  @override
  _ComicBookListState createState() => _ComicBookListState();

  static double calculateHeight(BuildContext context, double preferredHeight, int coversOnScreen) {
    final maxWidth = MediaQuery.of(context).size.width / coversOnScreen;
    final maxHeight = maxWidth / ComicBookPanel.aspect;
    return math.min(preferredHeight, maxHeight);
  }
}

class _ComicBookListState extends State<ComicBookList> {

  @override
  Widget build(BuildContext context) {
    print('Comicbook list build');
    if(widget._height == 0 && widget.preferredHeight > 0) {
      final maxWidth = MediaQuery.of(context).size.width / widget.coversOnScreen;
      final maxHeight = maxWidth / ComicBookPanel.aspect;
      widget._height = math.min(widget.preferredHeight, maxHeight);
      widget._width = widget._height * ComicBookPanel.aspect;
      widget._padding = (MediaQuery.of(context).size.width - widget._width * widget.coversOnScreen) /
          (widget.coversOnScreen + 1);
    }

    var bloc = BlocProvider.of<ComicBookListBloc>(context);
    if(bloc.currentState.isEmpty) {
      bloc.dispatch(ListEvent());
    }

    return SizedBox(
      height: widget._height,
      child: ListView.builder(
        itemBuilder: (context, pos) {
          return Row(
            children: <Widget> [
              Container(width: widget._padding),
              SizedBox(
                width: widget._width,
                height: widget._height,
                child: ComicBookPanel(bloc.currentState.data[pos])
              ),
              Container(width: pos == bloc.currentState.size - 1 ? widget._padding : 0),
            ]
          );
        },
        itemCount: bloc.currentState.size,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
