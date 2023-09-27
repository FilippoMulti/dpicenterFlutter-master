import 'dart:math' as math;

import 'package:delta_e/delta_e.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

@immutable
class ExampleExpandableFab extends StatelessWidget {
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  const ExampleExpandableFab({Key? key}) : super(key: key);

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expandable Fab'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: 25,
        itemBuilder: (context, index) {
          return FakeItem(isBig: index.isOdd);
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.format_size),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
    this.openCloseSwitch,
    this.onCustomOpen,
    this.onCustomClose,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final ValueNotifier<bool>? openCloseSwitch;

  final VoidCallback? onCustomOpen;
  final VoidCallback? onCustomClose;

  @override
  ExpandableFabState createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  /*late final AnimationController _controller;
  late final Animation<double> _expandAnimation;*/

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _expandAnimations;

  /*bool _open = false;*/

  late ValueNotifier<bool> _openN;

  late List<ValueNotifier<bool>> _currentState;

  bool get open => _openN.value;

  set open(bool value) => setState(() => _openN.value = value);

  List<ValueNotifier<bool>> get currentState => _currentState;

  @override
  void initState() {
    super.initState();

    _openN = widget.openCloseSwitch ??
        ValueNotifier<bool>(widget.initialOpen ?? false);
    // _openN.addListener(_openNChanged);
    _currentState = List.generate(
        widget.children.length, (index) => ValueNotifier<bool>(_openN.value));

    _openN.addListener(_toggleAll);
    for (int index = 0; index < _currentState.length; index++) {
      _currentState[index].addListener(() => _toggleSingle(index));
    }
    /*_open = widget.initialOpen ?? false;*/

    _controllers = List.generate(
        widget.children.length,
        (index) => AnimationController(
              value: _openN.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              vsync: this,
            ));

    _expandAnimations = List.generate(
        widget.children.length,
        (index) => CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.easeOutQuad,
              parent: _controllers[index],
            ));

    /*_controller = AnimationController(
      value: _openN.value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );*/
  }

/*  void _openNChanged(){
    if (_openN.value){
      _showExpandingActionButtons();
    } else {
      _removeExpandingActionButtons();
    }
  }*/

  void _removeExpandingActionButtons() {
    for (var element in entries) {
      element.remove();
    }
    entries.clear();
  }

  void _toggleSingle(int index) {
    if (_currentState[index].value) {
      _controllers[index].forward();
    } else {
      _controllers[index].reverse();
    }
  }

  void toggleStateSingle(int index) {
    if (_currentState[index].value == true) {
      _currentState[index].value = false;
    } else {
      _currentState[index].value = true;
    }

    if (_currentState.any((element) => element.value == true)) {
      _openN.value = true;
    } else {
      _openN.value = false;
    }
  }

  void setStateSingle(int index, bool value) {
    _currentState[index].value = value;

    if (_currentState.any((element) => element.value == true)) {
      _openN.value = true;
    } else {
      _openN.value = false;
    }
  }

  void toggleState() {
    _openN.value = !_openN.value;
  }

  void setAllState(bool value) {
    for (int i = 0; i < widget.children.length; i++) {
      setStateSingle(i, value);
    }
  }

  @override
  void dispose() {
    _openN.removeListener(_toggleAll);
    // _openN.removeListener(_openNChanged);
    // _removeExpandingActionButtons();
    for (int index = 0; index < _currentState.length; index++) {
      _currentState[index].dispose();
      //print('CurrentState HasListeners: ${_currentState[index].hasListeners.toString()}');
    }
    //_controller.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  /*void _toggle() {
    setState(() {
      if (_openN.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }*/

  void _toggleAll() {
    setState(() {
      if (_openN.value) {
        for (int index = 0; index < _controllers.length; index++) {
          //_controllers[index].forward();
          _currentState[index].value = true;
        }
      } else {
        for (int index = 0; index < _controllers.length; index++) {
          //_controllers[index].reverse();
          _currentState[index].value = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /* return SizedBox.expand(
      child: CustomStack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );*/

    return Container(
      clipBehavior: Clip.none,
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          color: isDarkTheme(context)
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onPrimary,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: widget.onCustomClose ?? () => setAllState(false),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: isDarkTheme(context)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimations[i],
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  final List<OverlayEntry> entries = <OverlayEntry>[];

  void _showExpandingActionButtons() {
    OverlayState? overlayState = Overlay.of(context);
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      entries.add(OverlayEntry(builder: (context) {
        return _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimations[i],
          child: widget.children[i],
        );
      }));
    }
    overlayState?.insertAll(entries);
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _openN.value,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _openN.value ? 0.7 : 1.0,
          _openN.value ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _openN.value ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: isLightTheme(context)
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.primary,
            foregroundColor: isLightTheme(context)
                ? getForegroundColor()
                : Theme.of(context).colorScheme.onPrimary,
            onPressed: widget.onCustomOpen ?? toggleState,

            //widget.onCustomOpen ?? toggleState,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Color getForegroundColor() {
    Color colorBase = Colors.white;

    if (isDarkTheme(context)) {
      colorBase = Color.alphaBlend(
          Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary);
    } else {
      colorBase = Theme.of(context).colorScheme.primary;
    }

    LabColor labColorPrimary = getLabColor(colorBase);
    Color colorToCheck =
        colorBase.computeLuminance() > 0.5 ? Colors.black87 : Colors.white70;

    LabColor labColorDefault = getLabColor(colorToCheck);

    //double difference = computeColorDistance(primary, menuDefaultColor);
    double difference = deltaE76(labColorDefault, labColorPrimary);
    //print('difference: ' + difference.toString());
    //print('compute luminance: ' + colorBase.computeLuminance().toString());
    if (difference < 50) {
      return colorBase.computeLuminance() > 0.5
          ? Colors.white70
          : Colors.black87;
    }
    return colorToCheck;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: IgnorePointer(ignoring: progress.isDismissed, child: child!),
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton(
      {Key? key,
      this.onPressed,
      required this.icon,
      this.text,
      this.color,
      this.iconColor})
      : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String? text;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: color ?? theme.colorScheme.primary,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.primaryIconTheme,
        child: Tooltip(
          message: text,
          child: IconButton(
            onPressed: onPressed,
            color: iconColor,
            icon: icon,
          ),
        ),
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}

class CustomStack extends Stack {
  CustomStack({
    Key? key,
    Clip clipBehavior = Clip.none,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.expand,
    List<Widget> children = const <Widget>[],
  }) : super(
          key: key,
          clipBehavior: clipBehavior,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          children: children,
        );

  @override
  RenderStack createRenderObject(BuildContext context) {
    return RenderStack2(
      alignment: alignment,
      clipBehavior: clipBehavior,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
    );
  }
}

class RenderStack2 extends RenderStack {
  RenderStack2({
    List<RenderBox>? children,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.expand,
    Clip clipBehavior = Clip.none,
  }) : super(
          children: children,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          clipBehavior: clipBehavior,
        );

  @override
  bool hitTest(BoxHitTestResult result, {Offset? position}) {
    if (position != null) {
      if (hitTestChildren(result, position: position) ||
          hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }
}