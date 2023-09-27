//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
/*import 'package:bitsdojo_window_flutter3/bitsdojo_window.dart';*/
import 'package:bitsdojo_window_windows/bitsdojo_window_windows.dart'
    show WinDesktopWindow;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MultiWindowBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? width;

  const MultiWindowBorder(
      {Key? key, required this.child, required this.color, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWindowsApp =
        (!kIsWeb) && (defaultTargetPlatform == TargetPlatform.windows);

    // Only show border on Windows
    if (!isWindowsApp) {
      return child;
    }

    var borderWidth = width ?? 1;
    var topBorderWidth = width ?? 1;

    if (appWindow is WinDesktopWindow) {
      (appWindow as WinDesktopWindow)
          .setWindowCutOnMaximize(borderWidth.ceil());
    }

    if (isWindowsApp) {
      topBorderWidth += 1 / appWindow.scaleFactor;
    }
    final topBorderSide = BorderSide(color: color, width: topBorderWidth);
    final borderSide = BorderSide(color: color, width: borderWidth);

    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: topBorderWidth)),
        child: child);
  }
}
