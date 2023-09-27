import 'package:flutter/material.dart';

class Proxy extends StatefulWidget {
  final Widget child;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  final double? height;
  final double? width;

  const Proxy(
      {required this.child,
      this.top,
      this.left,
      this.bottom,
      this.right,
      this.height,
      this.width,
      Key? key})
      : super(key: key);

  @override
  ProxyState createState() => ProxyState();
}

class ProxyState extends State<Proxy> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.top,
        right: widget.right,
        left: widget.left,
        bottom: widget.bottom,
        height: widget.height,
        width: widget.width,
        child: widget.child);
  }
}
