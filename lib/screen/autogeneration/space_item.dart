/*
import 'package:dotted_border/dotted_border.dart';
import 'package:dpicenter/models/server/autogeneration/item.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:dpicenter/screen/autogeneration/circle_number.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class SpaceItem extends StatelessWidget {
  const SpaceItem(
      {required this.duration,
        required this.curve,
        this.left,
        this.right,
        this.bottom,
        this.top,
        this.height,
        this.width,
        required this.space,
        this.highlightColor,
        this.onClose,
        this.proportion = (670 / 1260),
        this.highlight = false,
        this.showRealDimension,
        required this.vmc,
        required this.constraints,
        required this.scaleFactor,
        required this.rowIndex,
        required this.spaceIndex,
        this.onDragUpdate,
        this.onDragEnd,
        this.canClose,
        this.onTap,
        this.onDraggableCanceled,
        this.onDragStarted,
        required this.parentKey,
        this.pointerOffset,
        Key? key})
      : super(key: key);
  final BoxConstraints constraints;
  final ValueNotifier<double> scaleFactor;
  final ValueNotifier<bool>? showRealDimension;
  final int rowIndex;
  final int spaceIndex;
  final Space space;
  final Vmc vmc;
  final bool highlight;
  final Function(Item? item, int rowIndex, int spaceIndex)? onClose;
  final bool? canClose;
  final DragUpdateCallback? onDragUpdate;
  final DragEndCallback? onDragEnd;
  final Function(Space space, int rowIndex, int spaceIndex)? onTap;
  final DraggableCanceledCallback? onDraggableCanceled;
  final Color? highlightColor;
  final double proportion;
  final Function(Space? space)? onDragStarted;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? height;
  final double? width;
  final Duration duration;
  final Curve curve;

  final ValueNotifier<Offset>? pointerOffset;

  final GlobalKey parentKey;

  @override
  Widget build(BuildContext context) {


    RenderBox box = parentKey.currentContext?.findRenderObject() as RenderBox;

    ThemeData themeData = Theme.of(context);
    */
/*_draggingChild = SizedBox(
      height: _getRowHeight(widget.rowIndex),
      width: _getContainerWidth(),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            child: SpaceItem(
              parentKey: widget.parentKey,
              duration: widget.duration,
              curve: widget.curve,
              left: widget.left,
              right: widget.right,
              bottom: widget.bottom,
              top: widget.top,
              height: widget.height,
              width: widget.width,
              space: widget.space,
              spaceIndex: widget.spaceIndex,
              rowIndex: widget.rowIndex,
              constraints: widget.constraints,
              scaleFactor: widget.scaleFactor,
              vmc: widget.vmc,
            ),
          ),
          Container(color: Colors.red.withAlpha(100))
        ],
      ),
    );*/ /*


    return AnimatedPositioned(
      left: */
/*isOnDrag && _currentDragOffset != null
          ? _currentDragOffset!.dx
          : */ /*
 left,
      right: right,
      bottom: bottom,
      top: */
/*isOnDrag && _currentDragOffset != null
          ? _currentDragOffset!.dy
          : */ /*
top,
      width: width,
      height: height,
      duration: */
/*isOnDrag ? const Duration(milliseconds: 0) :*/ /*
 duration,
      curve: curve,
      child: GestureDetector(
        onPanDown: (details) {
          pointerOffset?.value = (context.findRenderObject() as RenderBox)
              .globalToLocal(details.globalPosition);
        },
        onPanUpdate: (details) {
          Offset _pointerOffset=(context.findRenderObject() as RenderBox)
              .globalToLocal(details.globalPosition);
          onDragUpdate?.call(details);
          */
/*print("_pointerOffset: ${_pointerOffset.toString()}");
          Offset localPos =
              box?.globalToLocal(details.globalPosition) ?? Offset.zero;

          setState(() {
            //pointerOffset = box?.globalToLocal(pointerOffset) ?? Offset.zero;
            print("currentDragOffset1: ${_currentDragOffset.toString()}");
            _currentDragOffset = Offset(localPos.dx - _pointerOffset.dx,
                localPos.dy - _pointerOffset.dy);

            print("currentDragOffset2: ${_currentDragOffset.toString()}");
          });
*/ /*

          */
/*Offset offset =
              box?.globalToLocal(currentDragOffset) ?? const Offset(0, 0);*/ /*

        },
        onPanCancel: () {
  */
/*        setState(() {
            isOnDrag = false;
          });*/ /*

          onDraggableCanceled?.call(Velocity.zero, Offset.zero);
        },
        onPanStart: (details) {
          */
/*setState(() {
            isOnDrag = true;
          });*/ /*

          onDragStarted?.call(space);
        },
        onPanEnd: (details) {
          */
/*setState(() {
            isOnDrag = false;
          });*/ /*

          onDragEnd?.call(DraggableDetails(
              velocity: details.velocity, offset: Offset.zero));
        },
        */
/*onDraggableCanceled: widget.onDraggableCanceled,
        onDragStarted: widget.onDragStarted,
*/ /*

        */
/*    onDragCompleted: (){
          print("completed");
        },
        onDragEnd: widget.onDragEnd,

        onDragUpdate:
        widget.onDragUpdate,*/ /*

        */
/*data: space!,*/ /*

        */
/*childWhenDragging: null,*/ /*

        */
/*feedback: Material(
          type: MaterialType.transparency,
          child: Builder(
              builder: (context) {
                return Visibility(
                  child: SpaceItem(
                    space: widget.space,
                    spaceIndex: widget.spaceIndex,
                    rowIndex: widget.rowIndex,
                    constraints: widget.constraints,
                    scaleFactor: widget.scaleFactor,
                    vmc: widget.vmc,
                  ),
                );
              }
          ),
        ),*/ /*

        child: InkWell(
          onTap: () {
            onTap?.call(space, rowIndex, spaceIndex);
            */
/*  EditItem editItem = EditItem(item: widget.vmc.rows?[index].spaces[spaceIndex].item);
                                                  final result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                                    return editItem;
                                                  }));*/ /*

          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: space.item != null && highlight
                    ? highlightColor ??
                    Color.alphaBlend(themeData.highlightColor.withAlpha(50),
                        themeData.colorScheme.primary)
                        .withAlpha(50)
                    : null,
                borderRadius:
                _getContainerRadius(rowIndex, spaceIndex),
                border: space.item != null
                    ? Border.all(color: themeData.colorScheme.primary)
                    : Border.all(color: Colors.transparent)
              //(index==0 || index==widget.vmc.rows!.length-1) && (spaceIndex==0 || widget.vmc.rows![index].spaces[spaceIndex]==widget.vmc.rows![index].spaces.last) ? const BorderRadius.vertical(top: Radius.circular(20)) : null,
            ),
            height: _getRowHeight(-1),
            width: width,
            //_getContainerWidth(),
            child: DottedBorder(
              strokeWidth: space.item != null ? 0 : 0.2,
              color: space.item != null
                  ? Colors.transparent
                  : themeData.colorScheme.primary,
              child: Stack(
                children: [
                  ///creo griglia spazi

                  if (space.item != null)
                    Positioned(
                      // duration: const Duration(milliseconds: 500),

                      left: 0,
                      bottom: 0,
                      top: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(

                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0,
                                color: Theme.of(context).colorScheme.secondary),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withAlpha(50),
                          ),
                          duration: const Duration(milliseconds: 500),
                          height: _getContainerHeight(rowIndex, spaceIndex)!-8,
                          width: constraints.maxWidth,

                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: space.item != null
                                  ? _getEngines2()
                                  : [
                                if (vmc.rows![rowIndex].maxWidthSpaces! -
                                    vmc.rows![rowIndex].maxPosition >=
                                    1.0)
                                  Icon(Icons.warning,
                                      size: 24 * scaleFactor.value,
                                      color: themeData.errorColor)
                              ]),
                        ),
                      ),
                    ),
                  */
/*Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (space!.item != null)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  space!.item!.code!,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontSize:
                                                          (_getRowHeight(-1) / 6)),
                                                ))),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Qta: ${space!.item!.itemConfiguration!.depthSpaces!.toInt()}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: _getRowHeight(-1) / 9),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: space!.item != null
                                ? _getEngines(widget.rowIndex, widget.spaceIndex,
                                    widget.constraints)
                                : [
                                    if (row!.maxWidthSpaces! - row!.maxPosition >=
                                        1.0)
                                      Icon(Icons.warning,
                                          size: 24 * widget.scaleFactor.value,
                                          color: Theme.of(context).errorColor)
                                  ]),
                      ],
                    ),*/ /*

                  if (space.item != null)
                    Positioned(
                      // duration: const Duration(milliseconds: 500),
                      left: 0,
                      top: 0,
                      width: width,
                      //_getContainerWidth(),
                      height: 24,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircleNumber(
                                toShow: space.item!.code!,
                                fontSize: 10,
                                color: themeData.colorScheme.primary,
                                onColor: themeData.colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircleNumber(
                                toShow: space
                                    .item!.itemConfiguration!.depthSpaces!
                                    .toInt()
                                    .toString(),
                                fontSize: 10,
                                color: Color.alphaBlend(
                                    themeData.colorScheme.primary
                                        .withAlpha(100),
                                    Colors.green),
                                onColor: themeData.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (space.item != null && (canClose ?? false))
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: IconButton(
                          constraints: null,
                          onPressed: () {
                            onClose?.call(
                              space.item,
                              rowIndex,
                              spaceIndex,
                            );
                          },
                          icon: const Icon(Icons.clear),
                          iconSize: 16,
                          splashRadius: 16,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          color: themeData.errorColor,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  List<Widget> _getEngines2() {
    try {
      double engineSize =
          constraints.heightConstraints().maxHeight * (72.5 / 1260);

      EngineType type = space.item!.itemConfiguration!.engineType;

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
                  (vmc.rows?.length ?? 1.0) *
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

  BorderRadius? _getContainerRadius(index, spaceIndex) {
    if (index == 0 && spaceIndex == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(4));
    }
    if (index == 0 &&
        vmc.rows![index].spaces[spaceIndex] ==
            vmc.rows![index].spaces.last) {
      return const BorderRadius.only(topRight: Radius.circular(4));
    }
    if (index == vmc.rows!.length - 1 && spaceIndex == 0) {
      return const BorderRadius.only(bottomLeft: Radius.circular(4));
    }
    if (index == vmc.rows!.length - 1 &&
        vmc.rows![index].spaces[spaceIndex] ==
            vmc.rows![index].spaces.last) {
      return const BorderRadius.only(bottomRight: Radius.circular(4));
    }
    return null;
  }

  double? _getContainerHeight(index, spaceIndex) {
    double height = space.item == null
        ? 1
        : (space.item!.itemConfiguration!.heightSpaces ?? 1);

    if (showRealDimension?.value ?? false) {
      return ((constraints.heightConstraints().maxHeight *
          scaleFactor.value *
          ((125 / 1260)) *
          height));
    }
    return _getRowHeight(index);
  }

  double _getRowHeight(index) {
    double rowSpace = (constraints.heightConstraints().maxHeight *
        scaleFactor.value /
        (vmc.rows?.length ?? 1.0));

    if (index == -1) {
      return rowSpace;
    }

    if (showRealDimension?.value ?? false) {
      double rowHeight = ((constraints.heightConstraints().maxHeight *
          ((125 / 1260) * scaleFactor.value) *
          (vmc.rows![index].maxHeight)));

      if (rowHeight > rowSpace) {
        rowSpace = rowHeight;
      }
    }
    return rowSpace;
  }

  double _getContainerWidth() {
    return space.item != null
        ? space.item!.itemConfiguration!.widthSpaces! *
        ((constraints.heightConstraints().maxHeight *
            scaleFactor.value *
            (proportion)) /
            vmc.rows!.length)
        : ((constraints.heightConstraints().maxHeight *
        scaleFactor.value *
        (proportion)) /
        vmc.rows!.length) *
        space.widthSpaces!;
  }
}
*/

import 'package:dotted_border/dotted_border.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:dpicenter/screen/autogeneration/circle_number.dart';
import 'package:flutter/material.dart';

class SpaceItem extends StatefulWidget {
  const SpaceItem(
      {required this.duration,
      required this.curve,
      this.left,
      this.right,
      this.bottom,
      this.top,
      this.height,
      this.width,
      required this.space,
      this.highlightColor,
      this.onClose,
      this.proportion = (670 / 1260),
      this.highlight = false,
      this.showRealDimension,
      required this.vmc,
      required this.constraints,
      required this.scaleFactor,
      required this.rowIndex,
      required this.spaceIndex,
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
  final int spaceIndex;
  final Space space;
  final Vmc vmc;
  final bool highlight;
  final Function(VmcItem? item, int rowIndex, int spaceIndex)? onClose;
  final bool? canClose;
  final DragUpdateCallback? onDragUpdate;
  final DragEndCallback? onDragEnd;
  final Function(Space space, int rowIndex, int spaceIndex)? onTap;
  final DraggableCanceledCallback? onDraggableCanceled;
  final Color? highlightColor;
  final double proportion;
  final Function(Space? space, Offset offset)? onDragStarted;

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
  State<StatefulWidget> createState() => SpaceItemState();
}

class SpaceItemState extends State<SpaceItem> {
  VmcRow? row;
  Space? space;

  Widget? _draggingChild;

  final double proportion = (670 / 1260);

  bool isOnDrag = false;

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
  Offset _pointerOffset = Offset.zero;
  RenderBox? box;

  @override
  Widget build(BuildContext context) {
    row = widget.vmc.rows![widget.rowIndex];
    space = widget
        .space; //widget.vmc.rows![widget.rowIndex].spaces[widget.spaceIndex];

    box = widget.parentKey.currentContext?.findRenderObject() as RenderBox;

    ThemeData themeData = Theme.of(context);
    _draggingChild = SizedBox(
      height: _getRowHeight(widget.rowIndex),
      width: _getContainerWidth(),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            child: SpaceItem(
              parentKey: widget.parentKey,
              duration: widget.duration,
              curve: widget.curve,
              left: widget.left,
              right: widget.right,
              bottom: widget.bottom,
              top: widget.top,
              height: widget.height,
              width: widget.width,
              space: widget.space,
              spaceIndex: widget.spaceIndex,
              rowIndex: widget.rowIndex,
              constraints: widget.constraints,
              scaleFactor: widget.scaleFactor,
              vmc: widget.vmc,
            ),
          ),
          Container(color: Colors.red.withAlpha(100))
        ],
      ),
    );

    return AnimatedPositioned(
      left: isOnDrag && _currentDragOffset != null
          ? _currentDragOffset!.dx
          : /* widget.selected ? widget.left! - 12.5 :*/ widget.left,
      right: widget.right,
      bottom: widget.bottom,
      top: isOnDrag && _currentDragOffset != null
          ? _currentDragOffset!.dy
          : /*widget.selected ? widget.top! - 12.5 :*/ widget.top,
      width: /*widget.selected ? widget.width! + 25 :*/ widget.width,
      height: /*widget.selected ? widget.height! + 25 : */ widget.height,
      duration: widget.selected || isOnDrag || widget.space.removed
          ? const Duration(milliseconds: 0)
          : widget.duration,
      curve: widget.curve,
      child: IgnorePointer(
        ignoring: !widget.space.visible,
        child: GestureDetector(
          onTapCancel: () {
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
            widget.onDragStarted?.call(space, details.globalPosition);
          },
          onPanEnd: (details) {
            setState(() {
              isOnDrag = false;
            });
            widget.onDragEnd?.call(DraggableDetails(
                velocity: details.velocity, offset: Offset.zero));
          },
          child: Visibility(
            visible: widget.visible,
            child: InkWell(
              onTap: () {
                widget.onTap?.call(space!, widget.rowIndex, widget.spaceIndex);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    color: space!.item != null && widget.highlight
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
                    /*borderRadius:
                        _getContainerRadius(widget.rowIndex, widget.spaceIndex),*/
                    border: space!.item != null
                        ? Border.all(color: themeData.colorScheme.primary)
                        : Border.all(color: Colors.transparent)
                    //(index==0 || index==widget.vmc.rows!.length-1) && (spaceIndex==0 || widget.vmc.rows![index].spaces[spaceIndex]==widget.vmc.rows![index].spaces.last) ? const BorderRadius.vertical(top: Radius.circular(20)) : null,
                    ),
                height: _getRowHeight(-1),
                width: widget.width,
                //_getContainerWidth(),
                child: DottedBorder(
                  strokeWidth: space!.item != null ? 0 : 0.2,
                  color: space!.item != null
                      ? Colors.transparent
                      : themeData.colorScheme.primary,
                  child: Stack(
                    children: getElements(themeData),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getInfoElement(ThemeData themeData) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      left: 0,
      top: 0,

      height: widget.canClose ?? false ? 0 : 24,
      width: widget.canClose ?? false ? 0 : widget.width,

      //_getContainerWidth(),

      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.canClose ?? false ? 0.0 : 1.0,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            direction: Axis.horizontal,
            children: [
              SizedBox(
                //duration: const Duration(milliseconds: 500),
                width: 16,
                height: 16,
                child: CircleNumber(
                  toShow: space!.item!.item.code!,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: widget.space.item != null &&
                          widget.space.item!.color != null
                      ? Color(widget.space.item!.color!)
                      : themeData.colorScheme.primary,
                  onColor: widget.space.item != null &&
                          widget.space.item!.color != null
                      ? Color(widget.space.item!.color!).computeLuminance() >
                              0.5
                          ? Colors.black.withAlpha(200)
                          : Colors.white.withAlpha(200)
                      : themeData.colorScheme.onPrimary,
                ),
              ),
              SizedBox(
                //  duration: const Duration(milliseconds: 500),
                width: 16,
                height: 16,
                child: CircleNumber(
                  toShow: space!.item!.itemConfiguration!.depthSpaces
                      .toInt()
                      .toString(),
                  fontSize: 10,
                  color: Color.alphaBlend(
                      themeData.colorScheme.primary.withAlpha(100),
                      Colors.green),
                  onColor: themeData.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getEnginesElement(ThemeData themeData) {
    double containerWidth = (widget.width ?? 0) - 6;
    double containerHeight =
        _getContainerHeight(widget.rowIndex, widget.spaceIndex)! - 8;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      left: 0,
      bottom: 0,
      top: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
                width: 0,
                color:
                widget.space.isNotEmpty && widget.space.item!.color != null
                    ? Color(widget.space.item!.color!)
                        : Theme.of(context).colorScheme.secondary),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: widget.space.isNotEmpty && widget.space.item!.color != null
                ? Color.alphaBlend(Color(widget.space.item!.color!),
                        Theme.of(context).colorScheme.secondary.withAlpha(50))
                    .withAlpha(70)
                : Theme.of(context).colorScheme.secondary.withAlpha(50),
          ),
          duration: const Duration(milliseconds: 500),
          height: containerHeight < 0 ? 0 : containerHeight,
          width: containerWidth < 0 ? 0 : containerWidth,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: space!.item != null
                  ? _getEngines2()
                  : [
                      if (row!.maxWidthSpaces - row!.maxPosition >= 1.0)
                        Icon(Icons.warning,
                            size: 24 * widget.scaleFactor.value,
                            color: themeData.errorColor)
                    ]),
        ),
      ),
    );
  }

  Widget getDeleteButton(ThemeData themeData) {
    return AnimatedPositioned(
      right: 0,
      top: 0,
      width: widget.canClose ?? false ? 16 : 0,
      height: 16,
      duration: const Duration(milliseconds: 500),
      child: AnimatedContainer(
        //alignment: Alignment.topRight,
        duration: const Duration(milliseconds: 500),
        width: widget.canClose ?? false ? 16 : 0,
        height: widget.canClose ?? false ? 16 : 0,
        child: AnimatedOpacity(
          opacity: widget.canClose ?? false ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: IconButton(
            constraints: null,
            onPressed: () {
              widget.onClose?.call(
                space!.item,
                widget.rowIndex,
                widget.spaceIndex,
              );
            },
            icon: const Icon(Icons.delete),
            iconSize: 16,
            splashRadius: 16,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            color: themeData.errorColor,
          ),
        ),
      ),
    );
  }

  List<Widget> getElements(ThemeData themeData) {
    return <Widget>[
      if (space!.item != null) getEnginesElement(themeData),
      if (space!.item != null) getInfoElement(themeData),
      if (space!.item != null) getDeleteButton(themeData),
    ];
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

  List<Widget> _getEngines2() {
    try {
      double engineSize =
          widget.constraints.heightConstraints().maxHeight * (72.5 / 1260) - 12;
      //(widget.constraints.heightConstraints().maxHeight * (72.5 / 1260));

      EngineType type = widget.space.item!.itemConfiguration!.engineType;

      switch (type) {
        case EngineType.single:
          return [
            AnimatedContainer(
                width: engineSize,
                height: engineSize,
                duration: const Duration(milliseconds: 500),
                child: Icon(
                  Icons.circle_outlined,
                  size: engineSize,
                    color: widget.space.item?.color != null
                        ? Color(widget.space.item!.color!)
                        : null))
          ];
        case EngineType.double:
          return [
            AnimatedContainer(
              width: engineSize,
              height: engineSize,
              duration: const Duration(milliseconds: 500),
              child: Icon(
                Icons.circle_outlined,
                size: engineSize,
                color: widget.space.item?.color != null
                    ? Color(widget.space.item!.color!)
                    : null,
              ),
            ),
            AnimatedContainer(
                width: engineSize,
                height: engineSize,
                duration: const Duration(milliseconds: 500),
                child: Icon(Icons.circle_outlined,
                    size: engineSize,
                    color: widget.space.item?.color != null
                        ? Color(widget.space.item!.color!)
                        : null)),
          ];

        case EngineType.doubleCustom:
          return [
            Icon(Icons.circle_outlined,
                size: engineSize,
                color: widget.space.item?.color != null
                    ? Color(widget.space.item!.color!)
                    : null),
            SizedBox(
              width: widget.constraints.heightConstraints().maxHeight /
                  (widget.vmc.rows?.length ?? 1.0) *
                  1,
            ),
            Icon(Icons.circle_outlined,
                size: engineSize,
                color: widget.space.item?.color != null
                    ? Color(widget.space.item!.color!)
                    : null)
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

  BorderRadius? _getContainerRadius(index, spaceIndex) {
    if (index == 0 && spaceIndex == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(4));
    }
    if (index == 0 &&
        widget.vmc.rows![index].spaces[spaceIndex] ==
            widget.vmc.rows![index].spaces.last) {
      return const BorderRadius.only(topRight: Radius.circular(4));
    }
    if (index == widget.vmc.rows!.length - 1 && spaceIndex == 0) {
      return const BorderRadius.only(bottomLeft: Radius.circular(4));
    }
    if (index == widget.vmc.rows!.length - 1 &&
        widget.vmc.rows![index].spaces[spaceIndex] ==
            widget.vmc.rows![index].spaces.last) {
      return const BorderRadius.only(bottomRight: Radius.circular(4));
    }
    return null;
  }

  double? _getContainerHeight(index, spaceIndex) {
    double height = space!.item == null
        ? 1
        : (space!.item!.itemConfiguration!.heightSpaces);

    if (widget.showRealDimension?.value ?? false) {
      return ((widget.constraints.heightConstraints().maxHeight *
          widget.scaleFactor.value *
          ((125 / 1260)) *
          height));
    }
    return _getRowHeight(index);
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

  double _getContainerWidth() {
    return space!.item != null
        ? space!.item!.itemConfiguration!.widthSpaces *
            ((widget.constraints.heightConstraints().maxHeight *
                    widget.scaleFactor.value *
                    (widget.proportion)) /
                widget.vmc.rows!.length)
        : ((widget.constraints.heightConstraints().maxHeight *
                    widget.scaleFactor.value *
                    (widget.proportion)) /
                widget.vmc.rows!.length) *
            space!.widthSpaces!;
  }
}
