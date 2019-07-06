import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_flutter/bloc/CharacterListBlock.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/bloc/ListState.dart';
import 'package:marvel_flutter/model/ComicBook.dart';
import 'package:marvel_flutter/ui/ComicBookPanel.dart';
import 'package:marvel_flutter/util/UiUtils.dart';

class ComicBookList extends StatefulWidget {

  final double width, height;
  final int coversOnScreen;

  ComicBookList(this.width, this.coversOnScreen) :
   height = (width - UiUtils.marginDefault) / coversOnScreen * ComicBookPanel.aspect;

  @override
  _ComicBookListState createState() => _ComicBookListState();
}

class _ComicBookListState extends State<ComicBookList> {

  @override
  Widget build(BuildContext context) {

    var bloc = BlocProvider.of<ComicBookListBloc>(context);
    if(bloc.currentState.isEmpty) {
      bloc.dispatch(ListEvent());
    }

    return BlocBuilder(
      bloc: bloc,
      builder: (_, ListState<ComicBook> state) {

        if(state.isEmpty) {
          return Container();
        }

        return SizedBox(
          height: widget.height,
          child: ListView.separated(
              separatorBuilder: (context, index) => VerticalDivider(width: UiUtils.marginDefault),
              itemBuilder: (context, pos) {
                return SizedBox(
                    width: widget.height / ComicBookPanel.aspect,
                    height: widget.height,
                    child: ComicBookPanel(state.data[pos])
                );
              },
              itemCount: state.size,
              scrollDirection: Axis.horizontal,
            ),
        );

      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
