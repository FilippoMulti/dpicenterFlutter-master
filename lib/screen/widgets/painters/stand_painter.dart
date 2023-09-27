import 'dart:ui';

import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class StandPainter extends CustomPainter {
  final Color standColor;
  final double engineSize;
  final int standType;

  const StandPainter(
      {required this.standColor,
      required this.engineSize,
      required this.standType});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = standColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    switch (standType) {
      case 1:
        canvas.drawPath(getLowerStandPath(size), paint1);
        break;
      case 2:
        canvas.drawPath(getHigherStandPath(size), paint1);
        break;
      default:
        break;
    }
  }

  Path getLowerStandPath(Size size) {
    double standSize = engineSize / 4;
    double standHeight = engineSize / 2.8;
    Path path = Path();
    path.moveTo(size.width / 2 - standSize, size.height);
    path.lineTo(size.width / 2 - standSize, size.height);
    path.lineTo(size.width / 2 - standSize, size.height - standHeight);
    path.lineTo(size.width / 2 + standSize, size.height - standHeight);
    path.lineTo(size.width / 2 + standSize, size.height);

    return path;
  }

  Path getHigherStandPath(Size size) {
    double standSize = engineSize / 2.3;
    double standHeight = engineSize / 2;

    Path path = Path();
    path.moveTo(size.width / 2 - standSize, size.height);
    path.lineTo(size.width / 2 - standSize, size.height);
    path.lineTo(size.width / 2 - standSize, size.height - standHeight);
    path.lineTo(size.width / 2 + standSize, size.height - standHeight);
    path.lineTo(size.width / 2 + standSize, size.height);

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is StandPainter) {
      return (oldDelegate.standColor != standColor);
    }
    return false;
  }
}
