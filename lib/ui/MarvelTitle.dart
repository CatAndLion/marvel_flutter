import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_flutter/util/UiUtils.dart';

class MarvelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(3),
      child: Text(
        'MARVEL',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Marvel',
          fontSize: 50,
        ),
      ),
      color: UiUtils.colorPrimary,
    );
  }
}
