import 'package:dpicenter/globals/theme_global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({required this.child, super.key, this.initialShape});

  final NotchedShape? initialShape;
  final Widget child;

  @override
  BottomNavigatorState createState() => BottomNavigatorState();
}

class BottomNavigatorState extends State<BottomNavigator> {
  NotchedShape? _shape;

  NotchedShape? get shape => _shape;

  set shape(NotchedShape? shape) {
    if (_shape != shape) {
      setState(() {
        _shape = shape;
      });
    }
  }

  @override
  void initState() {
    shape = widget.initialShape;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, //getBackgroundColor(context),
      child: BottomAppBar(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        color: isLightTheme(context)
            ? Theme.of(context).colorScheme.primary
            : Color.alphaBlend(
                Theme.of(context).colorScheme.surface.withAlpha(240),
                Theme.of(context).colorScheme.primary),
        shape: shape,
        child: widget.child,
      ),
    );
  }
}
