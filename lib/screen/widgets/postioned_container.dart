//import 'package:dpicenter/debug/debug_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:dpicenter/globals/size_without_context.dart' as size;

class PositionedContainer extends StatefulWidget {
  final Offset? offset;
  final VoidCallback? onPressed;
  final VoidCallback? onSelected;
  final Function(Offset offset)? onPanEnd;
  final Widget child;
  final PointerHoverEventListener? onHover;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;
  final VoidCallback? onHoverStart;
  final VoidCallback? onHoverEnd;

  const PositionedContainer(
      {Key? key,
      this.offset,
      this.onPressed,
      required this.child,
      this.onSelected,
      this.onPanEnd,
      this.onHover,
      this.onEnter,
      this.onExit,
      this.onHoverStart,
      this.onHoverEnd})
      : super(key: key);

  @override
  State<PositionedContainer> createState() => _PositionedContainerState();
}

class _PositionedContainerState extends State<PositionedContainer>
    with WidgetsBindingObserver {
  late Size _lastSize;
  late Offset _offset;
  bool isHover = false;
  bool isPan = false;

  @override
  void initState() {
    super.initState();
    _offset = widget.offset ?? const Offset(0, 0);
    _lastSize = WidgetsBinding.instance.window.physicalSize;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (kDebugMode) {
      //print("before: ${_lastSize.toString()}");
    }
    var logicalScreenSize = WidgetsBinding.instance.window.physicalSize /
        WidgetsBinding.instance.window.devicePixelRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;
    var newOffset = checkOffset(_offset);
    setState(() {
      _lastSize = Size(logicalWidth, logicalHeight);
      _offset = newOffset;
      if (kDebugMode) {
        //print("after: ${_lastSize.toString()}");
      }
    });
  }

  Offset checkOffset(Offset currentOffset) {
    double dx;
    double dy;

    dx = currentOffset.dx;
    dy = currentOffset.dy;

    if (currentOffset.dx < 0) {
      dx = 0;
    }
    if (currentOffset.dy < 0) {
      dy = 0;
    }
    /* if (_lastSize.width < currentOffset.dx + 56) {
      dx = _lastSize.width - 56;
    }
    if (_lastSize.height < currentOffset.dy + 56) {
      dy = _lastSize.height - 56;
    }*/
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: MouseRegion(
        onHover: (details) {
          //debugPrint("offset: ${_offset.toString()}");
          //debugPrint("localPosition: ${details.localPosition.toString()}");
          //debugPrint("position: ${details.position.toString()}");
          if (!isHover) {
            isHover = true;
            widget.onHoverStart?.call();
          }
          widget.onHover?.call(details);
        },
        onEnter: (details) {
          widget.onEnter?.call(details);

          if (!isHover) {
            isHover = true;
            widget.onHoverStart?.call();
          }
        },
        onExit: (details) {
          if (isPan == false && isHover) {
            isHover = false;
            widget.onHoverEnd?.call();
          }
        },
        child: GestureDetector(
          onPanStart: (details) {
            debugPrint("onPanStart");
            isPan = true;
          },
          onPanDown: (details) {
            debugPrint("onPanDown");
            //  debugPrint("offset: ${_offset.toString()}");
            //  debugPrint("localPosition: ${details.localPosition.toString()}");
            //  debugPrint("globalPosition: ${details.globalPosition.toString()}");
            widget.onSelected?.call();
          },
          onTapUp: (details) {},
          onPanUpdate: (d) {
            isPan = true;
            //debugPrint("onPanUpdate");
            var currentOffset = _offset += Offset(d.delta.dx, d.delta.dy);
            var newOffset = checkOffset(currentOffset);

            setState(() {
              _offset = Offset(newOffset.dx, newOffset.dy);
              /*Offset newOffset = _offset + Offset(d.delta.dx, d.delta.dy);


          double width = WidgetsBinding.instance!.window.physicalGeometry.width;
          print(WidgetsBinding.instance!.window..physicalGeometry.width);
          double height = WidgetsBinding.instance!.window.physicalSize.height* WidgetsBinding.instance!.window.physicalSize.aspectRatio;
          if ((newOffset.dx <= width-64) && (newOffset.dy <= height-64)){
            _offset += Offset(d.delta.dx, d.delta.dy);
          }
*/
            });
          },
          onPanEnd: (details) {
            debugPrint("onPanEnd");
            isPan = false;
            widget.onPanEnd?.call(_offset);
          },
          onPanCancel: () {
            debugPrint("onPanCancel");
            isPan = false;
            widget.onPanEnd?.call(_offset);
          },
          child: widget.child,
        ),
      ),
    );
  }
}
