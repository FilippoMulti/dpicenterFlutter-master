import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/screen/widgets/dashboard/_my_text_painter.dart';
import 'package:dpicenter/screen/widgets/multi_text_animation/font_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dashboard/ascii_art_generator.dart';

///a differenza di TextAnimation questa versione utilizza import 'package:auto_size_text/auto_size_text.dart';
class TextClockAnimation extends StatefulWidget {
  //final String text;
  final bool rotate;
  final bool rotateCanvas;
  final bool scale;
  final bool blur;
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
  final String dateFormat;
  final String timeFormat;
  final bool changeRandomLetter;
  final Duration blurTimeoutDuration;
  final Duration colorTimeoutDuration;
  final double maxBlur;
  final bool showInfo;

  const TextClockAnimation(
      {Key? key,
      this.showInfo = false,
      this.rotateCanvas = true,
      this.dateFormat = 'dd/MM/yyy',
      this.timeFormat = 'HH:mm:ss',
      this.maxBlur = 7.0,
      this.changeRandomLetter = false,
      this.containerBorderRadius,
      this.changeBackgroundColor = false,
      //  required this.text,
      this.maxScale = 2.0,
      this.fontSize = 24,
      this.scale = true,
      this.blur = true,
      this.blurDuration = const Duration(seconds: 4),
      this.rotateDuration = const Duration(seconds: 60),
      this.scaleDuration = const Duration(seconds: 10),
      this.textStyleDuration = const Duration(milliseconds: 200),
      this.blurTimeoutDuration = const Duration(seconds: 5),
      this.timeoutDuration = const Duration(seconds: 10),
      this.fastTimeoutDuration = const Duration(milliseconds: 200),
      this.scaleTimeoutDuration = const Duration(milliseconds: 1000),
      this.colorTimeoutDuration = const Duration(milliseconds: 5000),
      this.rotate = false})
      : super(key: key);

  @override
  TextClockAnimationState createState() => TextClockAnimationState();
}

class TextClockAnimationState extends State<TextClockAnimation>
    with TickerProviderStateMixin {
  final ScrollController _scrollControllerVertical =
      ScrollController(debugLabel: '_scrollControllerVertical');
  final ScrollController _scrollControllerHorizontal =
      ScrollController(debugLabel: '_scrollControllerHorizontal');
  int indexRow1 = 0;
  int indexRow2 = 0;
  int asset = 0;
  Color _color = Colors.blue;
  Color _oldColor = Colors.blue;
  Color _strokeColor = Colors.black;
  int color = 0;
  int backColor = 0;
  double fontSize = 24;

/*  bool _assetsLoaded = false;
  bool _assetsLoading = false;*/
  String? renderedText;
  List<String> renderedDateLetters = <String>[];
  List<String> renderedTimeLetters = <String>[];

  double sigmaStart = 0;
  double sigmaEnd = 0;

  double _left = 0;
  double _top = 0;
  double _turns = 0;
  double _scale = 1;

  final List<double> _turnListRow1 = <double>[];
  final List<double> _turnListRow2 = <double>[];

  late AnimationController _controller;
  Animation<double>? animation;
  late AnimationController _colorController;
  Animation<Color?>? colorAnimation;

  late Timer _timer;
  late Timer _fastTimer;
  late Timer _scaleTimer;
  late Timer _clockTimer;
  late Timer _blurTimer;
  late Timer _colorTimer;

  //String text = '';
  /*final List<String> _assets = <String>[];*/

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleTimeout);

  Timer scheduleColorTimeout([int milliseconds = 10000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleColorTimeout);

  Timer scheduleClockTimeout([int milliseconds = 1000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleClockTimeout);

  Timer scheduleFastTimeout([int milliseconds = 200]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleFastTimeout);

  Timer scheduleScaleTimeout([int milliseconds = 1000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleScaleTimeout);

  Timer scheduleBlurTimeout([int milliseconds = 1000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleBlurTimeout);

  void handleColorTimeout(timer) {
    while (true) {
      color = Random().nextInt(Colors.primaries.length);
      _oldColor = _color;
      _color = Colors.primaries[color];
      if (_color.computeDifference(getAppBackgroundColor(context)) > 50) {
        break;
      } else {
        print("compute...");
      }
    }
    _refreshColorAnimation(_oldColor, _color);
    _colorController.reset();
    _colorController.forward();

    setState(() {
      backColor = Random().nextInt(Colors.primaries.length);
    });
  }

  void handleScaleTimeout(timer) {
    setState(() {
      if (widget.scale) {
        _scale = Random().nextDouble() * (widget.maxScale - 0.5) + 0.5;
      }
    });
  }

  void handleBlurTimeout(timer) {
    setState(() {
      if (widget.blur) {
        _refreshAnimation();
        _controller.reset();
        _controller.forward();
      }
    });
  }

  String _dateString = "";
  String _timeString = "";

  void handleClockTimeout(timer) {
    setState(() {
      _dateString =
          "Multi-Tech"; //DateFormat(widget.dateFormat).format(DateTime.now());
      _timeString = "Dpi Center"; //widget.timeFormat).format(DateTime.now());
      String completeText = "$_dateString $_timeString";
      //print("handleClockTimeout: $completeText");
      renderedDateLetters =
          renderString(_dateString, currentLetters: renderedDateLetters);
      renderedTimeLetters =
          renderString(_timeString, currentLetters: renderedTimeLetters);
    });
  }

  List<String> renderString(String string, {List<String>? currentLetters}) {
    List<String> result = <String>[];
    if (currentLetters?.isEmpty ?? true) {
      for (int index = 0; index < string.length; index++) {
        result.add(renderTextWithFont(fontAssets[asset], string[index]));
      }
    } else {
      if (widget.changeRandomLetter) {
        int randomLetter = Random().nextInt(currentLetters?.length ?? 0);
        currentLetters?[randomLetter] =
            renderTextWithFont(fontAssets[asset], string[randomLetter]);
        if (currentLetters != null) {
          result = currentLetters;
        }
      } else {
        for (int index = 0; index < string.length; index++) {
          result.add(renderTextWithFont(fontAssets[asset], string[index]));
        }
      }
    }
    return result;
  }

  void handleFastTimeout(timer) {
    setState(() {
      if (assetsLoaded) {
        asset = Random().nextInt(fontAssets.length);

        renderedDateLetters =
            renderString(_dateString, currentLetters: renderedDateLetters);
        renderedTimeLetters =
            renderString(_timeString, currentLetters: renderedTimeLetters);
      }
    });
  }

  int _isRotating = 0;

  void handleTimeout(timer) {
    _left = Random().nextDouble() * (2 - 0) + -0;
    _top = Random().nextDouble() * (2 - 0) + -0;
    setState(() {
      indexRow1++;
      if (indexRow1 >= _dateString.length) {
        indexRow1 = 0;
      }
      indexRow2++;
      if (indexRow2 >= _timeString.length) {
        indexRow2 = 0;
      }

      /*if (!widget.changeRandomLetter) {
        for (int index=0; index<text.length; index++){
          renderedTextLetters?.add(renderTextWithFont(fontAssets[asset], text[index]));
        }
      }*/
      //fontSize=24;

      /*fontSize =
          Random().nextDouble() * (widget.maxFontSize - widget.minFontSize) +
              widget.minFontSize;*/
      if (widget.rotate) {
        _isRotating++;
        if (assetsLoaded) {
          _turnListRow1.clear();

          for (int index = 0; index < _dateString.length; index++) {
            _turns = Random().nextDouble() * (4 - (-4)) + (-4);
            _turnListRow1.add(_turns);
          }
          _turnListRow2.clear();
          for (int index = 0; index < _timeString.length; index++) {
            _turns = Random().nextDouble() * (4 - (-4)) + (-4);
            _turnListRow2.add(_turns);
          }
        }
        /* color = Random().nextInt(Colors.primaries.length);
        backColor = Random().nextInt(Colors.primaries.length);*/
      }
      /*_color = Colors.primaries[color];*/
      /*_strokeColor =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];*/
    });
  }

  @override
  void initState() {
    super.initState();
    //text = widget.text.replaceAll(' ', '');
    fontSize = widget.fontSize;

    _timer = scheduleTimeout(widget.timeoutDuration.inMilliseconds);
    _clockTimer = scheduleClockTimeout();
    _fastTimer = scheduleFastTimeout(widget.fastTimeoutDuration.inMilliseconds);
    _scaleTimer =
        scheduleScaleTimeout(widget.scaleTimeoutDuration.inMilliseconds);
    _blurTimer = scheduleBlurTimeout(widget.blurTimeoutDuration.inMilliseconds);
    _colorTimer =
        scheduleColorTimeout(widget.colorTimeoutDuration.inMilliseconds);
    _controller =
        AnimationController(duration: widget.blurDuration, vsync: this);
    _colorController =
        AnimationController(duration: widget.textStyleDuration, vsync: this);
  }

  double _randomSigmaLarge() =>
      Random().nextDouble() * (widget.maxBlur - 0) + 0;

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

  void _refreshColorAnimation(Color start, Color end) {
    colorAnimation =
        ColorTween(begin: start, end: end).animate(_colorController)
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
    _clockTimer.cancel();
    _fastTimer.cancel();
    _scaleTimer.cancel();
    _blurTimer.cancel();
    _colorTimer.cancel();

    ///il controller delle animazioni va sempre distrutto prima di super.dispose
    _controller.dispose();
    _colorController.dispose();

    _scrollControllerHorizontal.dispose();
    _scrollControllerVertical.dispose();
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
          return LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                animatedWidget(constraints, blurAnimation: true),
                Opacity(
                    opacity: 0.70,
                    child: animatedWidget(constraints, blurAnimation: false)),
                if (widget.showInfo)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fonts[asset],
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        "sigmaStart: $sigmaStart sigmaEnd: $sigmaEnd",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "color: ${color.toString()}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "scale: ${_scale.toString()}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextButton(
                          onPressed: () {
                            print("Delete this: ${fonts[asset]}");
                          },
                          child: const Text("List")),
                    ],
                  )
              ],
            );
          });

          /*}
          return const Text("...");*/
        });
  }

  Widget animatedWidget(constraints,
      {bool blurAnimation = true, double fixedBlur = 1.0}) {
    return AnimatedContainer(
      width: constraints.maxWidth * 2,
      height: constraints.maxHeight * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: widget.changeBackgroundColor
              ? Colors.primaries[backColor].withAlpha(Random().nextInt(80))
              : null,
          borderRadius:
              widget.containerBorderRadius ?? BorderRadius.circular(20)),
      duration: Duration(milliseconds: Random().nextInt(1000)),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: _scrollControllerHorizontal,
          scrollDirection: Axis.horizontal,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: _scrollControllerVertical,
              scrollDirection: Axis.vertical,
              child: AnimatedScale(
                scale: _scale,
                duration: widget.scaleDuration,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dateTimeRow(renderedDateLetters, _turnListRow1,
                        blurAnimation: blurAnimation, fixedBlur: fixedBlur),
                    dateTimeRow(renderedTimeLetters, _turnListRow2,
                        blurAnimation: blurAnimation, fixedBlur: fixedBlur),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateTimeRow(List<String>? textToRender, List<double> turnList,
      {bool blurAnimation = true, double? fixedBlur}) {
    return AnimatedRotation(
        turns: widget.rotateCanvas ? ((_isRotating % 2) == 0 ? _turns : 0) : 0,
        duration: (_isRotating % 2) == 0
            ? widget.rotateDuration
            : const Duration(milliseconds: 5000),
        child: Row(
          children: List.generate(
            textToRender?.length ?? 0,
            (index) => AnimatedRotation(
              //filterQuality: FilterQuality.high,
              turns: (_isRotating % 2) == 0
                  ? (turnList.isNotEmpty ? turnList[index] : 0)
                  : 0,
              duration: (_isRotating % 2) == 0
                  ? widget.rotateDuration
                  : const Duration(milliseconds: 5000),
              child: AnimatedDefaultTextStyle(
                duration: widget.textStyleDuration,
                style: TextStyle(
                    fontSize: fontSize,
                    color: colorAnimation?.value,
                    fontFamily: 'Roboto Mono',
                    fontFeatures: const [FontFeature.tabularFigures()]),
                child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                        sigmaX: blurAnimation
                            ? animation?.value ?? 0
                            : fixedBlur ?? 0,
                        sigmaY: blurAnimation
                            ? animation?.value ?? 0
                            : fixedBlur ?? 0),
                    child: /*Text(
                    assetsLoaded
                        ? (textToRender?[index]) ?? 'loading...'
                        : 'loading...',
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),*/
                        CustomPaint(
                            size: Size(100, 200),
                            painter: MyTextPainter(
                              text: assetsLoaded
                                  ? (textToRender?[index]) ?? 'loading...'
                                  : 'loading...',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: colorAnimation?.value,
                                  fontFamily: 'Roboto Mono',
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ]),
                            ))),
              ),
            ),
          ),
        ));
  }
}
