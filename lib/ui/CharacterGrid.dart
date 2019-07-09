import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_flutter/bloc/ListBloc.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/bloc/ListState.dart';
import 'package:marvel_flutter/model/Character.dart' as model;
import 'package:marvel_flutter/model/Character.dart';
import 'package:marvel_flutter/ui/LoadingWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marvel_flutter/util/CharacterPageRoute.dart';
import 'package:marvel_flutter/ui/ComicTextPanel.dart';
import 'package:marvel_flutter/util/UiUtils.dart';

// Widget class
class CharacterGrid extends StatefulWidget {

  const CharacterGrid();

  @override
  _CharacterGridState createState() => _CharacterGridState();
}

// State class
class _CharacterGridState extends State<CharacterGrid> with TickerProviderStateMixin {

  CharacterListBloc bloc;

  final panelTextStyle = (UiUtils.textStyle as TextStyle)
      .copyWith(fontSize: UiUtils.textLarge);

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(onScroll);

    print("${this.runtimeType.toString()} initState");
    super.initState();
  }

  @override
  void dispose() {
    print("${this.runtimeType.toString()} dispose");
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("${this.runtimeType.toString()} build");

    bloc = BlocProvider.of<CharacterListBloc>(context);
    if(bloc.currentState.isEmpty) {
      bloc.dispatch(ListEvent(query: bloc.currentState.query));
    }

    return BlocBuilder(bloc: bloc,
        builder: (_, ListState<Character> state) {

          if(state.isEmpty && state.isLoading) {
            return Center(child: LoadingWidget('Assembling'),);
          }

          return CustomScrollView(
            controller: _scrollController,

            slivers: <Widget>[

              // grid items
              SliverPadding(
                padding: EdgeInsets.all(UiUtils.marginLarge),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: UiUtils.marginDefault,
                  crossAxisSpacing: UiUtils.marginDefault,
                  childAspectRatio: 0.8,
                  children: List.generate(state.size, (pos) {
                    return buildItem(state.data[pos]);
                  }),
                ),
              ),

              //loading item
              SliverList(
                delegate: SliverChildListDelegate(
                    <Widget>[
                      buildBottom()
                    ]),
              )
            ],
          );
    });
  }

  void onScroll() {
    if(bloc.currentError == null && !bloc.isLoading && bloc.canLoad &&
        _scrollController.offset >= _scrollController.position.maxScrollExtent) {
      // load next page
      bloc.dispatch(ListEvent(page: bloc.nextPage, query: bloc.currentState.query));
    }
  }

  Widget buildBottom() {
    if(bloc.currentError != null) {
      //error widget
      return Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: ComicTextPanel.yellow('Reload'),
              onPressed: () {
                if(!bloc.isLoading) {
                  bloc.dispatch(ListEvent(page: bloc.currentState.page,
                      query: bloc.currentState.query));
                }
              },
            ),
          ],
        ),
      );
    }
    if(bloc.canLoad) {
      return Center(
        heightFactor: 2,
        child: LoadingWidget('to be continue...'),
      );
    } else if(!bloc.hasData) {
      return Center(
        heightFactor: 2,
        child: Text('not found', style: UiUtils.textStyle,),
      );
    } else {
      return Container();
    }
  }

  Widget buildItem(model.Character item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CharacterPageRoute(item));
      },
      child: Hero(
        tag: item.id,
        child: Container(
          decoration: _getThumbnailPanel(item.thumbnail),

          child: Stack(
            children: <Widget>[

              Center(child: Opacity(
                opacity: item.thumbnail.available ? 0 : 1,
                child: Text("no image", style: panelTextStyle),
              )),

              Align(
                alignment: Alignment.bottomRight,
                child: _getNamePanel(item.name),
              ),

            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getThumbnailPanel(model.Image image) {
    return BoxDecoration(
      border: Border.all(
        color: Colors.black87,
        width: UiUtils.panelBorder,
      ),
      image: image.available ? DecorationImage(
          image: CachedNetworkImageProvider(image.url),
          fit: BoxFit.cover
      ) : null,
    );
  }

  Widget _getNamePanel(String name) {
    return Container(
      margin: EdgeInsets.all(UiUtils.marginDefault),
      child: ComicTextPanel.yellow(name),
    );
  }
}
