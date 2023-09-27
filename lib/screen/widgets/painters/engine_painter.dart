import 'dart:ui';

import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class EnginePainter extends CustomPainter {
  final double engineSize;
  final Color engineColor;
  final int dashes;
  final Color dashColor;
  final double gapSize;
  final double strokeWidth;

  const EnginePainter(
      {required this.engineSize,
      required this.engineColor,
      this.dashes = 20,
      this.dashColor = Colors.black,
      this.gapSize = 3.0,
      this.strokeWidth = 2.5});

  @override
  void paint(Canvas canvas, Size size) {
    /*final double gap = math.pi / 180 * gapSize;
    final double singleAngle = (math.pi * 2) / dashes;

    for (int i = 0; i < dashes; i++) {
      final Paint paint = Paint()
        ..color = dashColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
          Offset.zero & size, gap + singleAngle * i, singleAngle - gap * 2, false, paint);
    }
*/
    Rect rect = Rect.fromCircle(
      center: Offset(engineSize / 2, engineSize / 2),
      radius: math.min(engineSize / 2, engineSize / 2) - 4,
    );

    // a fancy rainbow gradient
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      tileMode: TileMode.repeated,
      colors: [engineColor, engineColor.darken(0.4)],
    );

    var paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

/*
    canvas.drawCircle( Offset(engineSize/2, engineSize/2), engineSize/2-4, paint1);*/

    //Path path =createSpiralPath2(size);
    /* PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath =
    pathMetric.extractPath(pathMetric.length * 0.10, pathMetric.length);
*/

    //canvas.drawPath(path, paint1);

    /*canvas.drawArc(
      rect,
      0.0,
      math.pi*2,
      false,
      paint1,
    );*/
    canvas.drawArc(
      rect,
      0.1,
      5.8,
      false,
      paint1,
    );
    var paint2 = Paint()
      ..color = getReadableColor(Colors.red.value.toString(), engineColor)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(engineSize / 2, engineSize / 2),
        height: engineSize,
        width: engineSize,
      ),
      0,
      0.3,
      false,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is EnginePainter) {
      return (oldDelegate.engineSize != engineSize ||
          oldDelegate.engineColor != engineColor);
    }
    return false;
  }

  Path createSpiralPath(Size size) {
    double radius = size.height / 2 - 2, angle = 0;
    Path path = Path();

    //path.lineTo(size.height/2, size.height/2);
    for (int n = 0; n < 150; n++) {
      radius -= 0.15;
      angle += (math.pi * 2) / 80;
      var x = size.width / 2 + radius * math.cos(angle);
      var y = size.height / 2 + radius * math.sin(angle);
      if (n == 0) {
        path.moveTo(x, y);
      }
      path.lineTo(x, y);
    }
    return path;
  }

  Path createSpiralPath2(Size size) {
    double radius = 0, angle = 0;
    Path path = Path();
    double x = 0, y = 0;
    int n = 0;
    //path.lineTo(size.height/2, size.height/2);
    while (x <= size.height && y <= size.height) {
      radius += 0.15;
      angle += (math.pi * 2) / 80;
      x = size.width / 2 + radius * math.cos(angle);
      y = size.height / 2 + radius * math.sin(angle);
      if (n == 0) {
        path.moveTo(x, y);
      }
      path.lineTo(x, y);
      n++;
      //print('n: ${n} - x: $x - y: $y - size.width: ${size.width } - size.height : ${size.height }');
    }
    return path;
  }

  Path createEnginePath(Size size) {
    double radius = 0, angle = 0;
    Path path = Path();
    path.addOval(Rect.fromCenter(
      center: Offset(engineSize / 2, engineSize / 2),
      height: engineSize,
      width: engineSize,
    ));

    path.addArc(
      Rect.fromCenter(
        center: Offset(engineSize / 2, engineSize / 2),
        height: engineSize,
        width: engineSize,
      ),
      0,
      0.3,
    );

    return path;
  }
}
