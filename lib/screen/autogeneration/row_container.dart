import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:flutter/material.dart';

class RowContainer extends StatefulWidget {
  const RowContainer(
      {required this.duration,
      required this.curve,
      this.left,
      this.right,
      this.bottom,
      this.top,
      this.height,
      this.width,
      required this.row,
      this.highlightColor,
      this.onClose,
      this.proportion = (670 / 1260),
      this.highlight = false,
      this.showRealDimension,
      required this.vmc,
      required this.constraints,
      required this.scaleFactor,
      required this.rowIndex,
      this.onDragUpdate,
      this.onDragEnd,
      this.canClose,
      this.onTap,
      this.onDraggableCanceled,
      this.onDragStarted,
      required this.parentKey,
      this.visible = true,
      this.selected = false,
      this.onDragDown,
      Key? key})
      : super(key: key);
  final BoxConstraints constraints;
  final ValueNotifier<double> scaleFactor;
  final ValueNotifier<bool>? showRealDimension;
  final int rowIndex;
  final VmcRow row;
  final Vmc vmc;
  final bool highlight;
  final Function(VmcItem? item, int rowIndex, int spaceIndex)? onClose;
  final bool? canClose;
  final DragUpdateCallback? onDragUpdate;
  final DragEndCallback? onDragEnd;
  final Function(VmcRow row, int rowIndex)? onTap;
  final DraggableCanceledCallback? onDraggableCanceled;
  final Color? highlightColor;
  final double proportion;
  final Function(VmcRow? row, Offset offset)? onDragStarted;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? height;
  final double? width;
  final Duration duration;
  final Curve curve;

  final GlobalKey parentKey;

  final bool visible;
  final bool selected;
  final Function(Offset offset)? onDragDown;

  @override
  State<StatefulWidget> createState() => RowContainerState();
}

class RowContainerState extends State<RowContainer> {
  VmcRow? row;

  Widget? _draggingChild;

  final double proportion = (670 / 1260);

  //bool isOnDrag = false;

  @override
  void initState() {
    //debugPrint('spaceItem initState: ${widget.vmc.rows![widget.rowIndex].toString()}');
    super.initState();
  }

/*  double _getWidthSingle() {
    return ((widget.constraints.heightConstraints().maxHeight *
            widget.scaleFactor.value *
            (proportion)) /
        widget.vmc.rows!.length);
  }*/

  Offset? _currentDragOffset;
  final Offset _pointerOffset = Offset.zero;
  RenderBox? box;

  @override
  Widget build(BuildContext context) {
    row = widget.row;

    box = widget.parentKey.currentContext?.findRenderObject() as RenderBox;

    ThemeData themeData = Theme.of(context);

    return AnimatedPositioned(
      left: /*isOnDrag && _currentDragOffset != null
          ? _currentDragOffset!.dx
          :*/ /* widget.selected ? widget.left! - 12.5 :*/ widget
          .left,
      right: widget.right,
      bottom: widget.bottom,
      top: /*isOnDrag && _currentDragOffset != null
          ? _currentDragOffset!.dy
          :*/ /*widget.selected ? widget.top! - 12.5 :*/ widget
          .top,
      width: /*widget.selected ? widget.width! + 25 :*/ widget.width,
      height: /*widget.selected ? widget.height! + 25 : */ widget.height,
      duration: widget.selected
          ? const Duration(milliseconds: 0)
          : /*isOnDrag
              ? const Duration(milliseconds: 0)
              :*/
          widget.duration,
      curve: widget.curve,
      child: IgnorePointer(
        ignoring: false,
        child: GestureDetector(
          onTapCancel: () {
            print(
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<cancel");
          },
          /*onPanDown: (details) {
            _pointerOffset = (context.findRenderObject() as RenderBox)
                .globalToLocal(details.globalPosition);
            widget.onDragDown?.call(_pointerOffset);
          },
          onPanUpdate: (details) {

            print("_pointerOffset: ${_pointerOffset.toString()}");
            Offset localPos =
                box?.globalToLocal(details.globalPosition) ?? Offset.zero;

            setState(() {
              //pointerOffset = box?.globalToLocal(pointerOffset) ?? Offset.zero;
              print("currentDragOffset1: ${_currentDragOffset.toString()}");
              _currentDragOffset = Offset(localPos.dx - _pointerOffset.dx,
                  localPos.dy - _pointerOffset.dy);

              print("currentDragOffset2: ${_currentDragOffset.toString()}");
            });
            widget.onDragUpdate?.call(details);



          },
          onPanCancel: () {
            setState(() {
              _currentDragOffset = null;
              isOnDrag = false;
            });
            widget.onDraggableCanceled?.call(Velocity.zero, Offset.zero);
          },
          onPanStart: (details) {
            setState(() {
              _currentDragOffset = null;
              isOnDrag = true;
            });
            widget.onDragStarted?.call(row, details.globalPosition);
          },
          onPanEnd: (details) {
            setState(() {
              isOnDrag = false;
            });
            widget.onDragEnd?.call(DraggableDetails(
                velocity: details.velocity, offset: Offset.zero));
          },*/
          child: Visibility(
            visible: widget.visible,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              onTap: () {
                widget.onTap?.call(widget.row, widget.rowIndex);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: widget.highlight
                      ?
                      /* widget.selected ?
                        isDarkTheme(context) ?
                            Colors.black : Colors.white
                        :*/
                      widget.highlightColor ??
                          Color.alphaBlend(
                                  themeData.highlightColor.withAlpha(50),
                                  themeData.colorScheme.primary)
                              .withAlpha(50)
                      : null,

                  /*    _getContainerRadius(widget.rowIndex, widget.spaceIndex),*/
                  /* border: space!.item != null
                        ? Border.all(color: themeData.colorScheme.primary)
                        : Border.all(color: Colors.transparent)*/
                  //(index==0 || index==widget.vmc.rows!.length-1) && (spaceIndex==0 || widget.vmc.rows![index].spaces[spaceIndex]==widget.vmc.rows![index].spaces.last) ? const BorderRadius.vertical(top: Radius.circular(20)) : null,
                ),
                height: _getRowHeight(-1),
                width: widget.width,
                //_getContainerWidth(),
                child: AnimatedContainer(
                  height: widget.height,
                  width: widget.width,
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: isDarkTheme(context)
                        ? Colors.black.withAlpha(100)
                        : Colors.white.withAlpha(100),
                  ),
                  /*  child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: widget.height,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.secondary)),
                      );
                    })*/
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getEngines(int index, int spaceIndex, constraints) {
    try {
      double engineSize =
          widget.constraints.heightConstraints().maxHeight * (72.5 / 1260);

      EngineType type = widget.vmc.rows![index].spaces[spaceIndex].item!
          .itemConfiguration!.engineType;

      switch (type) {
        case EngineType.single:
          return [Icon(Icons.circle_outlined, size: engineSize)];
        case EngineType.double:
          return [
            Icon(Icons.circle_outlined, size: engineSize),
            Icon(Icons.circle_outlined, size: engineSize),
          ];

        case EngineType.doubleCustom:
          return [
            Icon(Icons.circle_outlined, size: engineSize),
            SizedBox(
              width: constraints.heightConstraints().maxHeight /
                  (widget.vmc.rows?.length ?? 1.0) *
                  1,
            ),
            Icon(Icons.circle_outlined, size: engineSize)
          ];
          break;
        default:
          return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  double _getRowHeight(index) {
    double rowSpace = (widget.constraints.heightConstraints().maxHeight *
        widget.scaleFactor.value /
        (widget.vmc.rows?.length ?? 1.0));

    if (index == -1) {
      return rowSpace;
    }

    if (widget.showRealDimension?.value ?? false) {
      double rowHeight = ((widget.constraints.heightConstraints().maxHeight *
          ((125 / 1260) * widget.scaleFactor.value) *
          (row!.maxHeight)));

      //if (rowHeight > rowSpace) {
      rowSpace = rowHeight;
      //}
    }
    return rowSpace;
  }
}
