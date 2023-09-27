//import 'package:dpicenter/debug/debug_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:dpicenter/globals/size_without_context.dart' as size;

class TopButton extends StatefulWidget {
  final Offset? offset;
  final VoidCallback? onPressed;

  const TopButton({Key? key, this.offset, this.onPressed}) : super(key: key);

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> with WidgetsBindingObserver {
  late Size _lastSize;
  late Offset _offset;

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
    if (_lastSize.width < currentOffset.dx + 56) {
      dx = _lastSize.width - 56;
    }
    if (_lastSize.height < currentOffset.dy + 56) {
      dy = _lastSize.height - 56;
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onPanUpdate: (d) {
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
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: widget.onPressed,
          child: const Icon(Icons.bug_report, color: Colors.white),
        ),
      ),
    );
  }
}
