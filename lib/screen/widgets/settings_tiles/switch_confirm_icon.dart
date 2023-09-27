import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';

class SwitchConfirmIcon extends StatefulWidget {
  const SwitchConfirmIcon(
      {this.size = 32,
      this.duration = const Duration(seconds: 1),
      required this.state,
      Key? key})
      : super(key: key);

  final double size;
  final Duration duration;
  final bool state;

  @override
  SwitchConfirmIconState createState() => SwitchConfirmIconState();
}

class SwitchConfirmIconState extends State<SwitchConfirmIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
  }

  void showCheck() {
    _controller.forward();
  }

  void resetCheck() {
    _controller.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.state) {
      showCheck();
    } else {
      resetCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCheck(
      progress: _animation,
      size: widget.size,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
