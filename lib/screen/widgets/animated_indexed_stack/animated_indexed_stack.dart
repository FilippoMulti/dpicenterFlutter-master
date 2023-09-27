import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration? duration;

  const AnimatedIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 350),
  }) : super(key: key);

  @override
  AnimatedIndexedStackState createState() => AnimatedIndexedStackState();
}

class AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _index = 0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      //reverseDuration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _index = widget.index;
    _controller.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    print("didUpdateWidget---------------");
    if (widget.index != _index) {
      _controller.reverse().then((_) {
        setState(() => _index = widget.index);
        _controller.forward();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Transform.scale(
            scale: 1.015 - (_controller.value * 0.015),
            child: child,
          ),
        );
      },
      child: IndexedStack(
        index: _index,
        children: widget.children,
      ),
    );
  }
}
