
import 'package:flutter/material.dart';
import 'package:marvel_flutter/model/ComicBook.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marvel_flutter/util/UiUtils.dart';

class ComicBookPanel extends StatelessWidget {

  static const double aspect = 850 / 553;

  final ComicBook item;

  ComicBookPanel(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: item.thumbnail.available ? CachedNetworkImage(imageUrl: item.thumbnail.url) :
              Text('no image', style: UiUtils.textStyle),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 1)
        ]
      ),
    );
  }
}
