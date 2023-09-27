import 'package:dpicenter/screen/widgets/resizable_widget/resizable_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'drag_distance.dart';

class ResizableWidget extends StatefulWidget {
  const ResizableWidget({
    Key? key,
    required this.child,
    required this.controller,
    required this.dragWidget,
    required this.dragWidgetHeight,
    required this.dragWidgetWidth,
    required this.tag,
    this.usePoints = false,
  }) : super(key: key);

  final ResizableWidgetController controller;
  final Widget child;
  final Widget dragWidget;
  final double dragWidgetHeight;
  final double dragWidgetWidth;
  final bool usePoints;
  final String tag;

  @override
  State<ResizableWidget> createState() => ResizableWidgetState();
}

class ResizableWidgetState extends State<ResizableWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResizableWidgetController>(
      key: ValueKey(widget.tag),
      tag: widget.tag,
      global: false,
      init: widget.controller,
      builder: (controller) {
        return SizedBox(
          height: controller.height,
          width: controller.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: controller.top,
                left: controller.left,
                height: controller.height,
                width: controller.width,
                child: widget.child,
              ),
              Positioned(
                top: controller.top - widget.dragWidgetHeight / 2,
                left: controller.left - widget.dragWidgetWidth / 2,
                height: controller.height + widget.dragWidgetHeight,
                width: controller.width + widget.dragWidgetWidth,
                child: Visibility(
                  visible: controller.showDragWidgets,
                  child: widget.usePoints
                      ? Stack(
                          children: [
                            // top left
                            Align(
                              alignment: Alignment.topLeft,
                              child: DragDistance(
                                onDrag: controller.onTopLeftDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // top center
                            Align(
                              alignment: Alignment.topCenter,
                              child: DragDistance(
                                onDrag: controller.onTopCenterDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // top right
                            Align(
                              alignment: Alignment.topRight,
                              child: DragDistance(
                                onDrag: controller.onTopRightDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // center left
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DragDistance(
                                onDrag: controller.onCenterLeftDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // center
                            Align(
                              alignment: Alignment.center,
                              child: DragDistance(
                                onDrag: controller.onCenterDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // center right
                            Align(
                              alignment: Alignment.centerRight,
                              child: DragDistance(
                                onDrag: controller.onCenterRightDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // bottom left
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: DragDistance(
                                onDrag: controller.onBottomLeftDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // bottom center
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: DragDistance(
                                onDrag: controller.onBottomCenterDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // bottom right
                            Align(
                              alignment: Alignment.bottomRight,
                              child: DragDistance(
                                onDrag: controller.onBottomRightDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            // top left
                            Align(
                              alignment: Alignment.topLeft,
                              child: DragDistance(
                                onDrag: controller.onTopLeftDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // top center
                            Positioned(
                              top: 0,
                              left: widget.dragWidgetWidth,
                              width: controller.width - widget.dragWidgetWidth,
                              height: widget.dragWidgetHeight,
                              child: DragDistance(
                                onDrag: controller.onTopCenterDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // top right
                            Align(
                              alignment: Alignment.topRight,
                              child: DragDistance(
                                onDrag: controller.onTopRightDrag,
                                child: widget.dragWidget,
                              ),
                            ),

                            // center left
                            Positioned(
                              top: widget.dragWidgetHeight,
                              left: 0,
                              width: widget.dragWidgetHeight,
                              height:
                                  controller.height - widget.dragWidgetHeight,
                              child: DragDistance(
                                onDrag: controller.onCenterLeftDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // center
                            Align(
                              alignment: Alignment.center,
                              child: DragDistance(
                                onDrag: controller.onCenterDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // center right
                            Positioned(
                              top: widget.dragWidgetHeight,
                              left: controller.width,
                              width: widget.dragWidgetWidth,
                              height:
                                  controller.height - widget.dragWidgetHeight,
                              child: DragDistance(
                                onDrag: controller.onCenterRightDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // bottom left
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: DragDistance(
                                onDrag: controller.onBottomLeftDrag,
                                child: widget.dragWidget,
                              ),
                            ),

                            // bottom center
                            Positioned(
                              top: controller.height,
                              left: widget.dragWidgetWidth,
                              width: controller.width - widget.dragWidgetWidth,
                              height: widget.dragWidgetHeight,
                              child: DragDistance(
                                onDrag: controller.onBottomCenterDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                            // bottom right
                            Align(
                              alignment: Alignment.bottomRight,
                              child: DragDistance(
                                onDrag: controller.onBottomRightDrag,
                                child: widget.dragWidget,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
