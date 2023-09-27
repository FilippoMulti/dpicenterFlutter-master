import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:dpicenter/screen/widgets/multi_text_animation/text_animation_font_provider.dart';
import 'package:flutter/material.dart';

import '../dashboard/ascii_art_generator.dart';

///a differenza di TextAnimation questa versione utilizza import 'package:auto_size_text/auto_size_text.dart';
class TextAnimationChild extends StatefulWidget {
  final String text;
  final bool cycleLetters;
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

  const TextAnimationChild(
      {Key? key,
      required this.text,
      required this.cycleLetters,
      this.maxScale = 2.0,
      this.fontSize = 24,
      this.scale = true,
      this.blurDuration = const Duration(seconds: 4),
      this.rotateDuration = const Duration(seconds: 60),
      this.scaleDuration = const Duration(seconds: 10),
      this.textStyleDuration = const Duration(milliseconds: 200),
      this.timeoutDuration = const Duration(seconds: 10),
      this.fastTimeoutDuration = const Duration(milliseconds: 200),
      this.rotate = false})
      : super(key: key);

  @override
  TextAnimationChildState createState() => TextAnimationChildState();
}

class TextAnimationChildState extends State<TextAnimationChild>
    with SingleTickerProviderStateMixin {
  int index = 0;
  int asset = 0;
  Color _color = Colors.blue;
  Color _strokeColor = Colors.black;
  int color = 0;
  int backColor = 0;
  double fontSize = 24;
  final bool _assetsLoaded = false;
  final bool _assetsLoading = false;
  String? renderedText;
  double sigmaStart = 0;
  double sigmaEnd = 0;

  double _left = 0;
  double _top = 0;
  double _turns = 0;
  double _scale = 1;

  late AnimationController _controller;
  Animation<double>? animation;

  late Timer _timer;
  late Timer _fastTimer;
  String text = '';
  final List<String> _assets = <String>[];

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleTimeout);

  Timer scheduleFastTimeout([int milliseconds = 200]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleFastTimeout);

  void handleFastTimeout(timer) {
    _refreshAnimation();

    setState(() {
      color = Random().nextInt(Colors.primaries.length);
      _color = Colors.primaries[color];
    });
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

      if (widget.scale) {
        _scale = Random().nextDouble() * (widget.maxScale - 0.5) + 0.5;
      }
      /*fontSize =
          Random().nextDouble() * (widget.maxFontSize - widget.minFontSize) +
              widget.minFontSize;*/
      if (widget.rotate) {
        _turns = Random().nextDouble() * (4 - (-4)) + (-4);
        color = Random().nextInt(Colors.primaries.length);
        backColor = Random().nextInt(Colors.primaries.length);
      }
      _color = Colors.primaries[color];
      _strokeColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
      if (_assetsLoaded) {
        asset = Random().nextInt(_assets.length);
        String toRender = text;
        if (widget.cycleLetters) {
          toRender = text[index];
        }
        renderedText = renderTextWithFont(_assets[asset], toRender);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    text = widget.text.replaceAll(' ', '');
    fontSize = widget.fontSize;

    _timer = scheduleTimeout(widget.timeoutDuration.inMilliseconds);
    _fastTimer = scheduleFastTimeout(widget.fastTimeoutDuration.inMilliseconds);
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getAsciiArt();
  }

  Widget getAsciiArt() {
    var state = FontProvider.of(context);
    return FutureBuilder<void>(
        future: state?.isLoaded(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          //if (snapshot.hasData){
          return AnimatedScale(
            scale: _scale,
            duration: widget.scaleDuration,
            child: AnimatedContainer(
                /*clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  // color: Colors.primaries[backColor].withAlpha(100),
                  borderRadius: BorderRadius.circular(20)),*/
                duration: Duration(milliseconds: Random().nextInt(5000)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      right: 0,
                      duration: const Duration(seconds: 5),
                      child: AnimatedRotation(
                        //filterQuality: FilterQuality.high,
                        turns: _turns,
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
                                snapshot.hasData
                                    ? renderedText ?? 'loading...'
                                    : 'loading...',
                                textAlign: TextAlign.center,
                                softWrap: false,
                                overflow: TextOverflow.visible,
                              ),
                            )

                            /*getStrokedText(

                        _assetsLoaded ? renderedText ?? 'error...' : 'loading...',
                        strokeColor: _strokeColor,
                        textColor: _color,
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                      ),*/
                            ),
                      ),
                    ),
                  ],
                )),
          );

          /*}
          return const Text("...");*/
        });
  }
}
