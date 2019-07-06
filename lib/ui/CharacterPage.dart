import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel_flutter/bloc/CharacterListBlock.dart';
import 'package:marvel_flutter/model/Character.dart';
import 'package:marvel_flutter/ui/CharacterDescriptionPanel.dart';
import 'package:marvel_flutter/ui/ComicTextPanel.dart';
import 'package:marvel_flutter/util/UiUtils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterPage extends StatefulWidget {

  final String title;
  final Character character;
  CharacterPage(this.title, this.character);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {

  ComicBookListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ComicBookListBloc(widget.character.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tag = widget.character.id;

    return Scaffold(

        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(
            fontSize: 42,
            fontFamily: 'Marvel',
            color: Colors.white,
          ),)
          ),

        body: Stack(
          children: <Widget>[
            Hero(
              tag: tag,
              child: Container(
                decoration: BoxDecoration(
                    image: widget.character.thumbnail.available ?
                    DecorationImage(
                        image: CachedNetworkImageProvider(widget.character.thumbnail.url),
                        fit: BoxFit.cover
                    ) : null
                ),
                child: Padding(
                  padding: EdgeInsets.all(UiUtils.marginLarge),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: ComicTextPanel.yellow(widget.character.name)
                  ),
                ),
              ),
            ),

            //comic book list
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocProvider(
                builder: (_) => bloc,
                child: CharacterDescriptionPanel(widget.character.description),
              )
            )

          ],
        )
    );
  }
}
