import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimateIcons extends StatefulWidget {
  const AnimateIcons({
    Key? key,

    /// The IconData that will be visible before animation Starts
    required this.startIcon,

    /// The IconData that will be visible after animation ends
    required this.endIcon,

    /// The callback on startIcon Press
    /// It should return a bool
    /// If true is returned it'll animate to the end icon
    /// if false is returned it'll not animate to the end icons
    required this.onStartIconPress,

    /// The callback on endIcon Press
    /// /// It should return a bool
    /// If true is returned it'll animate to the end icon
    /// if false is returned it'll not animate to the end icons
    required this.onEndIconPress,

    /// The size of the icon that are to be shown.
    this.startIconSize,
    this.endIconSize,

    /// AnimateIcons controller
    required this.controller,

    /// The color to be used for the [startIcon]
    this.startIconColor,

    // The color to be used for the [endIcon]
    this.endIconColor,

    /// The duration for which the animation runs
    this.duration,

    /// If the animation runs in the clockwise or anticlockwise direction
    this.clockwise,

    /// This is the tooltip that will be used for the [startIcon]
    this.startTooltip,

    /// This is the tooltip that will be used for the [endIcon]
    this.endTooltip,

    /// Elevation of FAB
    this.elevation,
  }) : super(key: key);

  final IconData startIcon, endIcon;
  final bool Function() onStartIconPress, onEndIconPress;
  final Duration? duration;
  final bool? clockwise;
  final double? elevation;
  final double? startIconSize;
  final double? endIconSize;
  final Color? startIconColor, endIconColor;
  final AnimateIconController controller;
  final String? startTooltip, endTooltip;

  @override
  _AnimateIconsState createState() => _AnimateIconsState();
}

class _AnimateIconsState extends State<AnimateIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    initControllerFunctions();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initControllerFunctions() {
    widget.controller.animateToEnd = () {
      if (mounted) {
        _controller.forward();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.animateToStart = () {
      if (mounted) {
        _controller.reverse();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.isStart = () => _controller.value == 0.0;
    widget.controller.isEnd = () => _controller.value == 1.0;
  }

  _onStartIconPress() {
    if (widget.onStartIconPress() && mounted) _controller.forward();
  }

  _onEndIconPress() {
    if (widget.onEndIconPress() && mounted) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double x = _controller.value;
    double y = 1.0 - _controller.value;
    double angleX = math.pi / 180 * (180 * x);
    double angleY = math.pi / 180 * (180 * y);

    Widget first() {
      final icon = Icon(widget.startIcon,
          size: widget.startIconSize, color: Colors.white);
      return Transform.rotate(
        angle: widget.clockwise ?? false ? angleX : -angleX,
        child: Opacity(
          opacity: y,
          child: FloatingActionButton(
            backgroundColor:
                widget.startIconColor ?? Theme.of(context).primaryColor,
            onPressed: _onStartIconPress,
            heroTag: null,
            elevation: widget.elevation,
            child: widget.startTooltip == null
                ? icon
                : Tooltip(
                    message: widget.startTooltip!,
                    child: icon,
                  ),
          ),
        ),
      );
    }

    Widget second() {
      final icon =
          Icon(widget.endIcon, size: widget.endIconSize, color: Colors.white);
      return Transform.rotate(
          angle: widget.clockwise ?? false ? -angleY : angleY,
          child: Opacity(
            opacity: x,
            child: FloatingActionButton(
              backgroundColor:
                  widget.endIconColor ?? Theme.of(context).primaryColor,
              onPressed: _onEndIconPress,
              elevation: widget.elevation,
              heroTag: null,
              child: widget.endTooltip == null
                  ? icon
                  : Tooltip(
                      message: widget.endTooltip!,
                      child: icon,
                    ),
            ),
          ));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        x == 1 && y == 0 ? second() : first(),
        x == 0 && y == 1 ? first() : second(),
      ],
    );
  }
}

class AnimateIconController {
  late bool Function() animateToStart, animateToEnd;
  late bool Function() isStart, isEnd;
}
