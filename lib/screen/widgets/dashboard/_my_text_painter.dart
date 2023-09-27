import 'dart:math';
import 'dart:ui';

import 'package:dpicenter/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class MyTextPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final bool vibrations;
  final bool rotations;
  final Offset offset;
  static double count = 0;

  const MyTextPainter(
      {required this.text,
      required this.style,
      this.vibrations = true,
      this.rotations = true,
      this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
/*  Paint line = Paint()
    ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
    ..strokeWidth = Random().nextDouble() * (199-0.1) + 0.1;

  if (count % 1 == 0) {
   */ /* canvas.drawLine(
        Offset(Random().nextDouble() * (1000 - 0) + 0,
        Random().nextDouble() * (1000 - 0) + 0),
        Offset(
        Random().nextDouble() * (1000 - 0) + 0,
        Random().nextDouble() * (1000 - 0) + 0), line);*/ /*

    canvas.drawLine(
        Offset(1,
            0),
        Offset(
            1,
            500), line);
  }
  if (count==60){
    count=0;
  }
  count++;*/
//canvas.skew(Random().nextDouble() * (0.5 - 0) + 0, Random().nextDouble() * (0.1 - 0) + 0);
    if (count % 20 == 0) {
      canvas.translate(Random().nextDouble() * (10 - 0) + 0,
          Random().nextDouble() * (200 - 0) + 0);
    }

    if (count == 60) {
      count = 0;
    }
    count++;

    bool rotate = Random().nextInt(463453223) % 20 == 0;
    if (rotations && rotate) {
      canvas.rotate(Random().nextInt(45) / 1.0);
    }

    // canvas.scale(Random().nextDouble() * (1.1 - 0.9) +0.9);

    bool flicker = Random().nextInt(49595948) % 20 == 0;
    if (vibrations && flicker) {
      for (int index = 0; index < 3; index += 1) {
        //   canvas.scale(Random().nextDouble()*(1.2-(-0.5) + (-0.5)));
        TextPainter textPainter = getPainter(style.copyWith(
          color: Color.alphaBlend(
                  style.color?.withAlpha(Random().nextInt(200)) ?? Colors.white,
                  Colors.primaries[index])
              .withAlpha(Random().nextInt(200)),
          /*letterSpacing: Random().nextDouble() * (2 - (-2) + (-2)),*/
        ));

        double dx = (index % 2 == 0)
            ? index *
                (Random().nextDouble() * (Random().nextInt(50) - (-50)) + (-50))
            : -index * 2;
        double dy = (index % 2 == 0)
            ? index *
                (Random().nextDouble() * (Random().nextInt(50) - (-50)) + (-50))
            : -index * 2;

        textPainter.paint(canvas, Offset(dx, 0));
      }
    } else {
      TextPainter textPainter = getPainter(style);
      textPainter.paint(canvas, offset);
    }
  }

  TextPainter getPainter(TextStyle style) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
        /*minWidth: 0,
      maxWidth: size.width,*/
        );
    return textPainter;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if ((oldDelegate as MyTextPainter).style != style ||
        oldDelegate.text != text) {
      return true;
    }
    return false;
  }
}
