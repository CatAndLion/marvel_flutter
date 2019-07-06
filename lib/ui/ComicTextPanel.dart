import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_flutter/util/UiUtils.dart';

class ComicTextPanel extends StatelessWidget {

  final String text;
  final Color color;
  final bool shadow;

  ComicTextPanel(this.text, this.color, this.shadow);

  ComicTextPanel.yellow(String text, {double fontSize = UiUtils.textDefault, bool shadow = true})
      : this(text, UiUtils.colorActive, shadow);

  ComicTextPanel.white(String text, {double fontSize = UiUtils.textDefault, bool shadow = true})
      : this(text, Colors.white, shadow);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UiUtils.marginDefault),
      child: Text(text, style: UiUtils.textStyle,),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black87, width: 2),
        boxShadow: shadow ? <BoxShadow>[
          BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 1)
        ] : null
      ),
    );
  }
}