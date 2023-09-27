import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SearchIntent extends Intent {}

class SearchShortcuts extends StatelessWidget {
  SearchShortcuts({
    Key? key,
    required this.child,
    required this.onSearchDetected,
    this.focusNode,
  }) : super(key: key);

  ///SHORTCUTS per la ricerca CTRL+F
  final _searchKeySet = LogicalKeySet(
    LogicalKeyboardKey.control, // Replace with control on Windows
    LogicalKeyboardKey.keyF,
  );
  final _searchKeySet2 = LogicalKeySet(
    LogicalKeyboardKey.f3, // Replace with control on Windows
  );
  final Widget child;
  final VoidCallback onSearchDetected;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: focusNode,
      autofocus: true,
      shortcuts: {
        _searchKeySet: SearchIntent(),
        _searchKeySet2: SearchIntent(),
      },
      actions: {
        SearchIntent: CallbackAction(onInvoke: (e) => onSearchDetected.call()),
      },
      child: child,
    );
  }
}
