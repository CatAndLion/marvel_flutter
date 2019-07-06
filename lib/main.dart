import 'package:flutter/material.dart';
import 'package:marvel_flutter/ui/MainPage.dart';
import 'package:marvel_flutter/util/UiUtils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MARVEL sureheroes',
      theme: ThemeData(
        primaryColor: UiUtils.colorPrimary
      ),
      home: MainPage(title: 'MARVEL'),

      debugShowCheckedModeBanner: false,
    );
  }
}