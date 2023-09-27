import 'package:dpicenter/globals/globals.dart';
import 'package:flutter/material.dart';

var pTheme = {
  'p': Theme.of(navigatorKey!.currentContext!).textTheme.bodyMedium!.copyWith(
      color: Color.alphaBlend(Colors.red.withAlpha(180),
          Theme.of(navigatorKey!.currentContext!).colorScheme.primary)),
};
