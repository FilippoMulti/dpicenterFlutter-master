import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../multi_text_animation/text_clock_animation.dart';

class ScreenSaver extends StatefulWidget {
  final Uint8List image;

  const ScreenSaver(this.image, {super.key});

  @override
  ScreenSaverState createState() => ScreenSaverState();
}

class ScreenSaverState extends State<ScreenSaver>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
      upperBound: 1,
      lowerBound: 0,
      //reverseDuration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    )..addListener(() {
        setState(() {
          //print("value changed!!!!!: " + _sizeAnimation!.value.toString());
        });
      });
    Future.delayed(Duration(milliseconds: 1000), () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _handleInteration(dynamic value) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: _handleInteration,
        onPointerMove: _handleInteration,
        onPointerHover: _handleInteration,
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaY: _animation.value * 20,
                sigmaX: _animation.value * 20,
              ),
              child: Image.memory(widget.image),
            ),
            const TextClockAnimation(
              maxBlur: 7.0,
              opacity: 0.50,
              showInfo: false,
              fastTimeoutDuration: Duration(milliseconds: 10000),
              timeoutDuration: Duration(milliseconds: 25000),
              scaleDuration: Duration(milliseconds: 15000),
              scaleTimeoutDuration: Duration(milliseconds: 15000),
              blurDuration: Duration(milliseconds: 5000),
              colorTimeoutDuration: Duration(milliseconds: 5000),
              textStyleDuration: Duration(milliseconds: 5000),
              maxScale: 2,
              rotate: true,
              rotateCanvas: true,
              scale: true,
            ),
          ],
        ));
  }
}
