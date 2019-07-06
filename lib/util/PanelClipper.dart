// Clipper class for rectangle with angled left side
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PanelClipper extends CustomClipper<Path> {

  final double angle;
  PanelClipper(this.angle);

  @override
  Path getClip(Size size) {
    final path = Path();
    final x = size.height / math.tan(angle);

    path.moveTo(0, size.height);
    path.lineTo(x, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}