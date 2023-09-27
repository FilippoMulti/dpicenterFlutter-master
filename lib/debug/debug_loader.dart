import 'package:flutter/material.dart';

class DebugLoader {
  static final DebugLoader appDebug = DebugLoader(); //<-- singleton
  ValueNotifier<bool> debugShowingNotifier = ValueNotifier(false);

  void showDebug() {
    debugShowingNotifier.value = true;
  }

  void hideDebug() {
    debugShowingNotifier.value = false;
  }
}

typedef SetStateCallback = void Function(void Function() fn);

class DebugDpi {
  static final DebugDpi debugDpi = DebugDpi(); //<-- singleton

  bool debug = false;

  SetStateCallback? setState;

  DebugDpi({this.setState});

  void showDebug() {
    debug = true;
    if (setState != null) {
      setState!;
    }
  }

  void hideDebug() {
    debug = false;
    if (setState != null) {
      setState!;
    }
  }

  void toggle() {
    if (debug) {
      debug = false;
    } else {
      debug = true;
    }
  }
}
