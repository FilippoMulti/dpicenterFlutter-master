import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:flutter/material.dart';

class RowHeader extends StatefulWidget {
  const RowHeader(
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
      this.onUp,
      this.onDown,
      required this.label,
      Key? key})
      : super(key: key);
  final Widget label;
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
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final GlobalKey parentKey;

  final bool visible;
  final bool selected;
  final Function(Offset offset)? onDragDown;

  @override
  State<StatefulWidget> createState() => RowHeaderState();
}

class RowHeaderState extends State<RowHeader> {
  VmcRow? row;

  Widget? _draggingChild;

  final double proportion = (670 / 1260);

  /*bool isOnDrag = false;*/

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
              : */
          widget.duration,
      curve: widget.curve,
      child: IgnorePointer(
        ignoring: false,
        child: GestureDetector(
          /*onTapCancel: () {
            print(
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<cancel");
          },
          onPanDown: (details) {
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Color.alphaBlend(
                      Theme.of(context).backgroundColor.withAlpha(200),
                      Theme.of(context).colorScheme.secondary),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary)),
              width: widget.width,
              height: widget.height,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                    onTap: () {},
                    child: Stack(
                      children: [
                        //if (widget.onUp!=null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: IgnorePointer(
                            ignoring: widget.onUp == null,
                            child: SizedBox(
                              //duration: const Duration(milliseconds: 500),
                              height: 16,
                              width: 16,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: widget.onUp != null ? 1.0 : 0.0,
                                child: IconButton(
                                    constraints: const BoxConstraints(
                                        minHeight: 0,
                                        minWidth: 0,
                                        maxHeight: 16,
                                        maxWidth: 16),
                                    visualDensity: VisualDensity.compact,
                                    splashRadius: 16,
                                    padding: EdgeInsets.zero,
                                    iconSize: 16,
                                    icon: const Icon(Icons.arrow_upward),
                                    onPressed: widget.onUp),
                              ),
                            ),
                          ),
                        ),

                        Center(child: widget.label),

                        //if (widget.onDown!=null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: IgnorePointer(
                            ignoring: widget.onDown == null,
                            child: SizedBox(
                              //transformAlignment: Alignment.topRight,
                              //duration: const Duration(milliseconds: 500),
                              height: 16,
                              width: 16,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: widget.onDown != null ? 1.0 : 0.0,
                                child: IconButton(
                                  constraints: const BoxConstraints(
                                      minHeight: 0,
                                      minWidth: 0,
                                      maxHeight: 16,
                                      maxWidth: 16),
                                  visualDensity: VisualDensity.compact,
                                  splashRadius: 16,
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  icon: const Icon(Icons.arrow_downward),
                                  onPressed: widget.onDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
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
