import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:dpicenter/screen/widgets/multi_text_animation/font_list.dart';
import 'package:flutter/material.dart';

import '../dashboard/ascii_art_generator.dart';

///a differenza di TextAnimation questa versione utilizza import 'package:auto_size_text/auto_size_text.dart';
class TextAnimationEx2 extends StatefulWidget {
  final String text;
  final bool rotate;
  final bool scale;
  final double fontSize;
  final double maxScale;
  final Duration blurDuration;
  final Duration scaleDuration;
  final Duration textStyleDuration;
  final Duration rotateDuration;
  final Duration timeoutDuration;
  final Duration fastTimeoutDuration;
  final Duration scaleTimeoutDuration;
  final BorderRadius? containerBorderRadius;
  final bool changeBackgroundColor;

  const TextAnimationEx2(
      {Key? key,
      this.containerBorderRadius,
      this.changeBackgroundColor = false,
      required this.text,
      this.maxScale = 2.0,
      this.fontSize = 24,
      this.scale = true,
      this.blurDuration = const Duration(seconds: 4),
      this.rotateDuration = const Duration(seconds: 60),
      this.scaleDuration = const Duration(seconds: 10),
      this.textStyleDuration = const Duration(milliseconds: 200),
      this.timeoutDuration = const Duration(seconds: 10),
      this.fastTimeoutDuration = const Duration(milliseconds: 200),
      this.scaleTimeoutDuration = const Duration(milliseconds: 1000),
      this.rotate = false})
      : super(key: key);

  @override
  TextAnimationEx2State createState() => TextAnimationEx2State();
}

class TextAnimationEx2State extends State<TextAnimationEx2>
    with SingleTickerProviderStateMixin {
  final List<String> _notWorkingFonts = <String>[];

  int index = 0;
  int asset = 0;
  Color _color = Colors.blue;
  Color _strokeColor = Colors.black;
  int color = 0;
  int backColor = 0;
  double fontSize = 24;

/*  bool _assetsLoaded = false;
  bool _assetsLoading = false;*/
  String? renderedText;
  List<String>? renderedTextLetters = <String>[];

  double sigmaStart = 0;
  double sigmaEnd = 0;

  double _left = 0;
  double _top = 0;
  double _turns = 0;
  double _scale = 1;

  final List<double> _turnList = <double>[];

  late AnimationController _controller;
  Animation<double>? animation;

  late Timer _timer;
  late Timer _fastTimer;
  late Timer _scaleTimer;

  String text = '';

  /*final List<String> _assets = <String>[];*/

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleTimeout);

  Timer scheduleFastTimeout([int milliseconds = 200]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleFastTimeout);

  Timer scheduleScaleTimeout([int milliseconds = 1000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleScaleTimeout);

  void handleScaleTimeout(timer) {
    setState(() {
      if (widget.scale) {
        _scale = Random().nextDouble() * (widget.maxScale - 0.5) + 0.5;
      }
    });
  }

  void handleFastTimeout(timer) {
    _refreshAnimation();

    setState(() {
      color = Random().nextInt(Colors.primaries.length);
      _color = Colors.primaries[color];
    });
    backColor = Random().nextInt(Colors.primaries.length);
    if (assetsLoaded) {
      asset = Random().nextInt(fontAssets.length);
      if (renderedTextLetters?.isEmpty ?? false) {
        for (int index = 0; index < text.length; index++) {
          renderedTextLetters
              ?.add(renderTextWithFont(fontAssets[asset], text[index]));
        }
      } else {
        int randomLetter = Random().nextInt(renderedTextLetters?.length ?? 0);
        renderedTextLetters?[randomLetter] =
            renderTextWithFont(fontAssets[asset], text[randomLetter]);
      }
      //String toRender = text;
      /*if (widget.cycleLetters) {
          toRender = text[index];
        }
        renderedText = renderTextWithFont(_assets[asset], toRender);*/

    }
  }

  void handleTimeout(timer) {
    _controller.reset();
    _controller.forward();

    _left = Random().nextDouble() * (2 - 0) + -0;
    _top = Random().nextDouble() * (2 - 0) + -0;
    setState(() {
      index++;
      if (index >= text.length) {
        index = 0;
      }

      //fontSize=24;

      /*fontSize =
          Random().nextDouble() * (widget.maxFontSize - widget.minFontSize) +
              widget.minFontSize;*/
      if (widget.rotate) {
        if (assetsLoaded) {
          _turnList.clear();
          for (int index = 0; index < text.length; index++) {
            _turns = Random().nextDouble() * (4 - (-4)) + (-4);
            _turnList.add(_turns);
          }
        }
        color = Random().nextInt(Colors.primaries.length);
        backColor = Random().nextInt(Colors.primaries.length);
      }
      _color = Colors.primaries[color];
      _strokeColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
  }

  @override
  void initState() {
    super.initState();
    text = widget.text.replaceAll(' ', '');
    fontSize = widget.fontSize;

    _timer = scheduleTimeout(widget.timeoutDuration.inMilliseconds);
    _fastTimer = scheduleFastTimeout(widget.fastTimeoutDuration.inMilliseconds);
    _scaleTimer =
        scheduleScaleTimeout(widget.scaleTimeoutDuration.inMilliseconds);
    _controller =
        AnimationController(duration: widget.blurDuration, vsync: this);
    // #docregion addListener
    _refreshAnimation();
    // #enddocregion addListener
  }

  double _randomSigmaLarge() => Random().nextDouble() * (10 - 0) + 0;

  double _randomSigmaTiny() => Random().nextDouble() * (2 - 0) + 0;

  void _refreshAnimation() {
    if (sigmaStart == 0 && sigmaEnd == 0) {
      sigmaStart = _randomSigmaLarge();
      sigmaEnd = _randomSigmaLarge();
    } else {
      sigmaStart = sigmaEnd;
      sigmaEnd = _randomSigmaLarge();
    }

    animation =
        Tween<double>(begin: sigmaStart, end: sigmaEnd).animate(_controller)
          ..addListener(() {
            // #enddocregion addListener
            setState(() {
              // The state that has changed here is the animation object’s value.
            });
            // #docregion addListener
          });
  }

  @override
  void dispose() {
    _timer.cancel();
    _fastTimer.cancel();
    _scaleTimer.cancel();

    ///il controller delle animazioni va sempre distrutto prima di super.dispose
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getAsciiArt();
  }

  Widget getAsciiArt() {
    /*if (renderedTextLetters?.isNotEmpty ?? false) {
      print('render: ${renderedTextLetters?[index]}');
    }*/
    return FutureBuilder<void>(
        future: loadFontAssets(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          //if (snapshot.hasData){
          return AnimatedScale(
              scale: _scale,
              duration: widget.scaleDuration,
              child: AnimatedContainer(
                  width: 4000,
                  height: 2000,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: widget.changeBackgroundColor
                          ? Colors.primaries[backColor]
                              .withAlpha(Random().nextInt(80))
                          : null,
                      borderRadius: widget.containerBorderRadius ??
                          BorderRadius.circular(20)),
                  duration: Duration(milliseconds: Random().nextInt(1000)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        renderedTextLetters?.length ?? 0,
                        (index) => AnimatedRotation(
                          //filterQuality: FilterQuality.high,
                          turns: _turnList.isNotEmpty ? _turnList[index] : 0,
                          duration: widget.rotateDuration,
                          child: AnimatedDefaultTextStyle(
                              duration: widget.textStyleDuration,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: _color,
                                  fontFamily: 'Roboto Mono',
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ]),
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                    sigmaX: animation?.value ?? 0,
                                    sigmaY: animation?.value ?? 0),
                                child: Text(
                                  assetsLoaded
                                      ? (renderedTextLetters?[index]) ??
                                          'loading...'
                                      : 'loading...',
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                ),
                              )),
                        ),
                      ),
                    ),
                  )));

          /*}
          return const Text("...");*/
        });
  }

  Future<void> _loadAssets() async {
    if (!assetsLoaded && !assetsLoading) {
      assetsLoading = true;
      fontAssets.clear();
      for (String font in fonts) {
        try {
          debugPrint('try load asset: $font');
          fontAssets.add(await loadAsset(font));
          debugPrint('loaded: $font');
        } catch (e) {
          _notWorkingFonts.add(font);
          debugPrint('error loading font: $font: $e');
        }
      }
      debugPrint("Not working font:\r\n");
      for (String font in _notWorkingFonts) {
        debugPrint(font);
      }

      assetsLoaded = true;
    }
  }
}
