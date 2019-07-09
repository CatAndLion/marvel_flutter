import 'package:flutter/material.dart';
import 'package:marvel_flutter/bloc/ListBloc.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/ui/CharacterGrid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_flutter/ui/MarvelTitle.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {

  bool _searchOpened = false;
  final _searchIcon = Icons.search;
  final _closeIcon = Icons.close;

  CharacterListBloc bloc;

  final _controller = TextEditingController();

  final textInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 3),
    borderRadius: BorderRadius.all(Radius.circular(0)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(onSearch);

    bloc = CharacterListBloc();
    bloc.addErrorListener((error) {
      if(error != null) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text(error.left.toString()),
            content: Text(error.right),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('${this.runtimeType.toString()} state changed ${state.toString()}');
    switch(state) {
      case AppLifecycleState.resumed: {
        bloc?.onResume();
        return;
      }
      case AppLifecycleState.paused: {
        bloc?.onPause();
        return;
      }
      default: return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: !_searchOpened ?
          MarvelTitle() :
          TextField(autofocus: false, controller: _controller,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 16, fontFamily:'Ace', color: Colors.black87),
            decoration: InputDecoration(hintMaxLines: 1,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(10),
              enabledBorder: textInputBorder,
              focusedBorder: textInputBorder,
              hintText: "character search",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          actions: <Widget>[
            IconButton(icon: Icon(!_searchOpened ? _searchIcon : _closeIcon),
              onPressed: _searchPressed,)
          ],
        ),
        body: BlocProvider<CharacterListBloc>(
          builder: (context) => bloc,
          child: const CharacterGrid(),
        )
    );
  }

  void _searchPressed() {
    setState(() {
      _searchOpened = !_searchOpened;
      if(!_searchOpened) {
        bloc.dispatch(ListEvent(page: 1));
      }
    });
  }

  void onSearch() {
    bloc.dispatch(ListEvent(query: _controller.text));
  }
}