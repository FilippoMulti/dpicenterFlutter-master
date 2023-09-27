import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class AdjustableScrollControllere extends ScrollController {
  AdjustableScrollControllere({String? debugLabel, int extraScrollSpeed = 80})
      : super(debugLabel: debugLabel) {
    super.addListener(() {
      ScrollDirection scrollDirection = super.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = super.offset +
            (scrollDirection == ScrollDirection.reverse
                ? extraScrollSpeed
                : -extraScrollSpeed);
        scrollEnd = min(super.position.maxScrollExtent,
            max(super.position.minScrollExtent, scrollEnd));
        jumpTo(scrollEnd);
      }
    });
  }
}
