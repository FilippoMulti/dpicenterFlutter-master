import 'package:flutter/material.dart';

class CircleNumber extends StatefulWidget {
  final double fontSize;
  final String? toShow;
  final Color? color;
  final Color? onColor;
  final FontWeight? fontWeight;

  const CircleNumber(
      {required this.toShow,
      required this.fontSize,
      this.fontWeight,
      this.color,
      this.onColor,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CircleNumberState();
}

class CircleNumberState extends State<CircleNumber> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              widget.toShow ?? '',
              style: TextStyle(
                  color: widget.onColor,
                  fontWeight: widget.fontWeight,
                  fontSize: widget.fontSize),
            )));
  }
}
