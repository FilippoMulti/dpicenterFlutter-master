import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/screen/widgets/resizable_widget/resizable_widget.dart';
import 'package:dpicenter/screen/widgets/resizable_widget/resizable_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResizableContainer extends StatefulWidget {
  final double dragWidgetSize;
  final Widget child;
  final bool usePoints;
  final Widget? dragWidget;
  final Offset? offset;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;

  final double? areaWidth;
  final double? areaHeight;
  final String tag;

  const ResizableContainer(
      {Key? key,
      this.usePoints = true,
      required this.tag,
      this.dragWidgetSize = 10,
      required this.child,
      this.dragWidget,
      this.height,
      this.width,
      this.minWidth,
      this.minHeight,
      this.offset,
      this.areaWidth,
      this.areaHeight})
      : super(key: key);

  @override
  State<ResizableContainer> createState() => _ResizableContainerState();
}

class _ResizableContainerState extends State<ResizableContainer> {
  late ResizableWidgetController _controller;
  late double areaHeight;
  late double areaWidth;

  @override
  void initState() {
    super.initState();

    areaHeight = widget.areaHeight ?? Get.height * 0.70;
    areaWidth = widget.areaWidth ?? Get.width * 0.70;

    _controller = Get.put(
      ResizableWidgetController(
        initialPosition: widget.offset ?? const Offset(0, 0),
        areaHeight: areaHeight,
        areaWidth: areaWidth,
        height: widget.height ?? 300,
        width: widget.width ?? 300,
        minWidth: widget.minWidth ?? 50,
        minHeight: widget.minHeight ?? 50,
      ),
      tag: widget.tag,
    );
  }

  @override
  void dispose() {
    Get.delete<ResizableWidgetController>();
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ResizableWidget(
        tag: widget.tag,
        dragWidgetHeight: widget.dragWidgetSize,
        dragWidgetWidth: widget.dragWidgetSize,
        controller: _controller,
        usePoints: widget.usePoints,
        dragWidget: widget.dragWidget ??
            Container(
              height: widget.dragWidgetSize,
              width: widget.dragWidgetSize,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: isDarkTheme(context)
                    ? Colors.transparent
                    : Colors.transparent,
              ),
            ),
        child: widget.child,
      );
    });
  }
}
