
import 'package:flutter/material.dart';
import 'package:marvel_flutter/model/Character.dart';
import 'package:marvel_flutter/ui/CharacterPage.dart';
import 'package:flutter/animation.dart';

class CharacterPageRoute extends PageRouteBuilder {

  CharacterPageRoute(Character item) : super(
    pageBuilder: (context, animation, animation2) => CharacterPage('MARVEL', item),
    transitionsBuilder: (context, animation, animation2, widget) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animation),
        child: widget,
      );
    }
  );
}