import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(
      milliseconds: 800,
    ),
  }) : super(key: key);

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.5);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = _controller.drive(CurveTween(curve: Curves.decelerate));

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
/*    return IndexedStack(
      index: widget.index,
      children: widget.children,
    );*/
    return FadeScaleTransition(
      animation: _animation,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );

/*
    return ZoomIn(
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );*/
  }
}
