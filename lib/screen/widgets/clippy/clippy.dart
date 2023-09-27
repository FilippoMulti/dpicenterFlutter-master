import 'package:flutter/material.dart';
import 'package:dpicenter/extensions/globalkey_extensions.dart';
import 'package:dpicenter/extensions/build_context_extension.dart';

class Clippy extends StatefulWidget {
  final Widget child;
  final Scrollable? scrollableWidget;
  final int currentState;
  final Map<GlobalKey, Widget>? schedule;

  const Clippy(
      {required this.child,
      this.currentState = 0,
      this.scrollableWidget,
      this.schedule,
      Key? key})
      : super(key: key);

  @override
  State<Clippy> createState() => ClippyState();

  static ClippyState of(BuildContext context) {
    final ClippyState? result = context.findAncestorStateOfType<ClippyState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ClippyState.of() called with a context that does not contain a Clippy.',
      ),
      ErrorDescription(
        'No ClippyState ancestor could be found starting from the context that was passed to ClippyState.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the Scaffold widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the DataScreenState. For an example of this, please see the '
        'documentation for ClippyState.of():\n'
        '  https://api.flutter.dev/flutter/material/Scaffold/of.html',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the DataScreenState. In this solution, '
        'you would have an outer widget that creates the DataScreenState populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use DataScreenState.of().\n'
        'A less elegant but more expedient solution is assign a GlobalKey to the DataScreenState, '
        'then use the key.currentState property to obtain the ScaffoldState rather than '
        'using the DataScreenState.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }
}

class ClippyState extends State<Clippy> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Rect> animation;
  Rect startingRect = Rect.zero;

  Widget? _currentScrollable;

  Widget? get currentScrollable => _currentScrollable;

  set currentScrollable(Widget? value) {
    setState(() {
      _currentScrollable = value;
    });
  }

  Map<GlobalKey, Widget>? schedule;

  int _page = 0;

  int get page => _page;

  set page(int value) {
    GlobalKey? key = schedule?.keys.elementAt(value);
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(key!.currentContext!,
          duration: const Duration(milliseconds: 300));
    }

    Future.delayed(
        const Duration(milliseconds: 500),
        () => setState(() {
          _page = value;
              Rect? rect = key?.currentContext?.globalPaintBounds;
              animation = Tween<Rect>(begin: startingRect, end: rect)
                  .animate(_controller);
              _controller
                  .forward(from: 0.0)
                  .whenComplete(() => startingRect = rect!);
            }));
  }

  int _currentState = 0;

  int get currentState => _currentState;

  set currentState(int value) {
    setState(() {
      _currentState = value;
    });
  }

  GlobalKey? _currentKey;

  GlobalKey? get currentKey => _currentKey;

  set currentKey(GlobalKey? value) {
    setState(() {
      currentState = 1;
      _currentKey = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey? key = schedule?.keys.elementAt(page);
    //Rect? rect = key?.currentContext?.globalPaintBounds;

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (currentState > 0)
            ClipPath(
              clipper: CenterHolePath(dimension: animation.value),
              child: Container(
                alignment: Alignment.center,
                color: Colors.yellow,
              ),
            ),
          if (currentState > 0 && schedule?[key] != null) schedule![key]!,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentState = 0; //widget.currentState;
    currentScrollable = widget.scrollableWidget;

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    animation = Tween<Rect>(begin: startingRect, end: startingRect)
        .animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class CenterHolePath extends CustomClipper<Path> {
  final Rect dimension;

  CenterHolePath({
    required this.dimension,
  });

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(dimension)
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CenterHolePath oldClipper) {
    return dimension != oldClipper.dimension;
  }
}