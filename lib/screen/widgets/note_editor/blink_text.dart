import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final String _target;
  final TextStyle? style;
  final TextAlign? textAlign;

  const BlinkingText(this._target, {this.style, this.textAlign, Key? key})
      : super(key: key);

  @override
  BlinkingTextState createState() => BlinkingTextState();
}

class BlinkingTextState extends State<BlinkingText> {
  bool _show = true;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      setState(() => _show = !_show);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Text(widget._target,
      textAlign: widget.textAlign,
      style: _show
          ? widget.style ?? const TextStyle()
          : widget.style?.copyWith(color: Colors.transparent) ??
              const TextStyle(color: Colors.transparent));

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
