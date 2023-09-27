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
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/screen/autogeneration/circle_number.dart';
import 'package:dpicenter/screen/autogeneration/stand_widget.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:dpicenter/screen/widgets/painters/engine_painter.dart';
import 'package:dpicenter/screen/widgets/painters/stand_painter.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class SpaceItemEx extends StatefulWidget {
  const SpaceItemEx(
      {required this.codeToShow,
      required this.vmc,
      required this.itemConfiguration,
      this.onPressed,
      this.showInfoElements = true,
      this.showQuotes = true,
      this.onLeftEngineTap,
      this.onRightEngineTap,
      this.onLeftEngineCancelTap,
      this.onRightEngineCancelTap,
      this.onStandTap,
      this.itemPictures,
      this.showEngineDegrees = false,
      Key? key})
      : super(key: key);

  final void Function()? onLeftEngineTap;
  final void Function()? onLeftEngineCancelTap;
  final void Function()? onRightEngineTap;
  final void Function()? onRightEngineCancelTap;
  final void Function()? onStandTap;

  ///visualizza le informazioni relative alla selezioni con piccole icone
  final bool showInfoElements;

  ///visualizza le info su altezza e larghezza
  final bool showQuotes;

  final String codeToShow;
  final SampleItemConfiguration itemConfiguration;
  final Vmc vmc;
  final List<SampleItemPicture>? itemPictures;
  final VoidCallback? onPressed;

  ///mostra i gradi di rotazione dei motori
  final bool showEngineDegrees;

  @override
  State<StatefulWidget> createState() => SpaceItemExState();
}

class SpaceItemExState extends State<SpaceItemEx> {
  @override
  void initState() {
    //debugPrint('spaceItem initState: ${widget.vmc.rows![widget.rowIndex].toString()}');
    super.initState();
  }

  double quotaHeight = 24;
  double infoElementsHeight = 24;

  double getWidth(BoxConstraints constraints) {
    double drawerHeight = getHeight(constraints);
    //double drawerHeight = widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
    ///proporzione tra l'altezza effettiva e quella disponibile (constraints.maxHeight)
    double proportion =
        drawerHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
    double singleSpace =
        widget.vmc.vmcPhysicsConfiguration!.contentWidth * proportion;
    double fullSpace = singleSpace * widget.itemConfiguration.widthSpaces;
    return fullSpace;
  }

  double getHeight(BoxConstraints constraints) {
    return constraints.maxHeight -
        (widget.showQuotes ? quotaHeight : 0) -
        (widget.showInfoElements ? infoElementsHeight : 0);
  }

  double getItemHeight(BoxConstraints constraints) {
    double maxHeight = getHeight(constraints);

    if (getHeightSpaces(constraints) > 1.0) {
      //l'item sarà più alto del cassetto
      return maxHeight;
    } else {
      //l'item starà all'interno del cassetto
      double proportion =
          maxHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
      return (widget.vmc.vmcPhysicsConfiguration!.drawerHeight *
              widget.itemConfiguration.heightSpaces) *
          proportion;
    }

    return widget.vmc.vmcPhysicsConfiguration!.contentHeight *
        widget.itemConfiguration.heightSpaces;
  }

/*
  double getItemHeight(BoxConstraints constraints) {
    double maxHeight = getHeight(constraints);

    if (widget.itemConfiguration.heightSpaces > 1.0) {
      //l'item sarà più alto del cassetto
      return maxHeight;
    } else {
      //l'item starà all'interno del cassetto
      double proportion =
          maxHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
      return (widget.vmc.vmcPhysicsConfiguration!.drawerHeight *
          widget.itemConfiguration.heightSpaces) *
          proportion;
    }

    return widget.vmc.vmcPhysicsConfiguration!.contentHeight *
        widget.itemConfiguration.heightSpaces;
  }
*/

  double getHeightSpaces(BoxConstraints constraints) {
    double heightSpaces = 0;
    if (StandType.fromType(widget.itemConfiguration.stand) !=
        StandType.notVisible) {
      double standHeightSpaces = StandState.standEngineHeightFraction(
          StandType.fromType(widget.itemConfiguration.stand));
      double engineDrawerProportion =
          widget.vmc.vmcPhysicsConfiguration!.contentWidth /
              widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
      heightSpaces = engineDrawerProportion / standHeightSpaces;
    }
    return widget.itemConfiguration.heightSpaces + heightSpaces;
  }

  /*double getDrawerHeight(BoxConstraints constraints) {
    double maxHeight = getHeight(constraints);


    if (widget.itemConfiguration.heightSpaces > 1.0) {
      //l'item sarà più alto del cassetto
      */ /*double proportion = maxHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
      return (widget.vmc.vmcPhysicsConfiguration!.contentHeight * widget.itemConfiguration.heightSpaces) * proportion;
      */ /*
      //double proportion = maxHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;

      double proportion = 1.0 / widget.itemConfiguration.heightSpaces;
      return maxHeight * proportion;
    } else {
      //l'item starà all'interno del cassetto
      return maxHeight;
    }
  }*/

  double getDrawerHeight(BoxConstraints constraints) {
    double maxHeight = getHeight(constraints);

    if (getHeightSpaces(constraints) > 1.0) {
      //l'item sarà più alto del cassetto
      /*double proportion = maxHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;
      return (widget.vmc.vmcPhysicsConfiguration!.contentHeight * widget.itemConfiguration.heightSpaces) * proportion;
      */
      //double proportion = maxHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;

      double proportion = 1.0 / getHeightSpaces(constraints);
      return maxHeight * proportion;
    } else {
      //l'item starà all'interno del cassetto
      return maxHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      //constraints contiene lo spazio disponibile per disegnare questo space
      //devo calcolare quando spazio occuperebbe un singolo spazio se qui fosse possibile disegnare il cassetto completo
      //poi ridimensiono il singolo spazio

      debugPrint(
          "height: ${getHeight(constraints)}, width: ${getWidth(constraints)}");
      return InkWell(
        onTap: widget.onPressed,
        child: Column(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: getHeight(constraints),
                  width: constraints.maxWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: getElements(themeData, constraints),
                  ),
                ),
              ),
            ),
            if (widget.showInfoElements) getInfoElement(themeData, constraints)
          ],
        ),
      );
    });
  }

  Widget getNotesElements(ThemeData themeData, BoxConstraints constraints) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: quotaHeight,
      height: 24,
      //widget.canClose ?? false ? 0 : 24,
      width: getWidth(constraints),

      //_getContainerWidth(),

      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            direction: Axis.horizontal,
            children: [
              if (widget.itemConfiguration.notes.isNotEmpty)
                Container(
                    //  duration: const Duration(milliseconds: 500),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary)),
                    width: 20,
                    height: 20,
                    child: PopupMenuButton(
                        tooltip: 'Note',
                        constraints: const BoxConstraints(maxWidth: 1500),
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        itemBuilder: (BuildContext context) => List.generate(
                              widget.itemConfiguration.notes.length,
                              (index) => PopupMenuItem(
                                value: index,
                                child: Note.fromSampleItemNote(
                                    widget.itemConfiguration.notes[index],
                                    context),
                              ),
                            ),
                        child: Icon(
                          Icons.notes,
                          semanticLabel: 'Note',
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ))),
              if (widget.itemPictures?.isNotEmpty ?? false)
                Container(
                    //  duration: const Duration(milliseconds: 500),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary)),
                    width: 20,
                    height: 20,
                    child: PopupMenuButton(
                        tooltip: 'Immagini',
                        constraints: const BoxConstraints(maxWidth: 1500),
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        itemBuilder: (BuildContext context) => List.generate(
                              1,
                              (index) => PopupMenuItem(
                                  value: index,
                                  child: MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ServerDataBloc<Media>>(
                                        lazy: false,
                                        create: (context) =>
                                            ServerDataBloc<Media>(
                                                repo: MultiService<Media>(
                                                    Media.fromJsonModel,
                                                    apiName: "Media")),
                                      ),
                                      BlocProvider<PictureBloc>(
                                        lazy: false,
                                        create: (context) => PictureBloc(),
                                      ),
                                    ],
                                    child: ImageLoader(
                                      showButtons: false,
                                      onLoaded: (List<ItemPicture> values) {},
                                      itemPictures: widget.itemPictures
                                              ?.map((e) => e.toItemPicture())
                                              .toList() ??
                                          [],
                                    ),
                                  )

                                  /*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/
                                  ),
                            ),
                        child: Icon(
                          Icons.image,
                          semanticLabel: 'Note',
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget getInfoElement(ThemeData themeData, BoxConstraints constraints,
      {bool expand = true}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: infoElementsHeight,
      width: expand ? constraints.maxWidth : getWidth(constraints),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    //  duration: const Duration(milliseconds: 500),
                    width: 20,
                    height: 20,
                    child: Tooltip(
                      message:
                          'Profondità: ${widget.itemConfiguration.depthSpaces.toInt().toString()}',
                      child: CircleNumber(
                        toShow: widget.itemConfiguration.depthSpaces
                            .toInt()
                            .toString(),
                        fontSize: 14,
                        color: Color.alphaBlend(
                            themeData.colorScheme.primary.withAlpha(100),
                            Colors.green),
                        onColor: themeData.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  if (widget.itemConfiguration.packaging != PackageType.no)
                    const SizedBox(width: 4),
                  if (widget.itemConfiguration.packaging != PackageType.no)
                    Container(
                      //  duration: const Duration(milliseconds: 500),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      width: 20,
                      height: 20,
                      child: Tooltip(
                          message:
                              widget.itemConfiguration.packaging.toString(),
                          child: Icon(
                            widget.itemConfiguration.packaging.toIconData(),
                            semanticLabel: 'Imbustare',
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                  if (widget.itemConfiguration.flap) const SizedBox(width: 4),
                  if (widget.itemConfiguration.flap)
                    Container(
                      //  duration: const Duration(milliseconds: 500),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      width: 20,
                      height: 20,
                      child: Tooltip(
                          message: 'Montare aletta',
                          child: Icon(
                            Icons.switch_access_shortcut,
                            semanticLabel: 'Montare aletta',
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                  if (!widget.itemConfiguration.photoCell)
                    const SizedBox(width: 4),
                  if (!widget.itemConfiguration.photoCell)
                    Container(
                      //  duration: const Duration(milliseconds: 500),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      width: 20,
                      height: 20,
                      child: Tooltip(
                          message:
                              'Disattiva la fotocellula per questo prodotto',
                          child: Icon(
                            Icons.sensors_off,
                            semanticLabel:
                                'Disattiva la fotocellula per questo prodotto',
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                  /* Container(
                      //  duration: const Duration(milliseconds: 500),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      width: 20,
                      height: 20,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            leftEngineTurns -= 15 / 360;
                            rightEngineTurns -= 15 / 360;
                            */ /*    if (leftEngineTurns<=-1){
                            leftEngineTurns=0;
                          }*/ /*
                          });
                        },
                        child: Tooltip(
                            message: 'Aletta',
                            child: Icon(
                              Icons.switch_access_shortcut,
                              semanticLabel: 'Aletta',
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                      )),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStandTappableIcon(
    double engineSize,
    void Function()? onTap,
    void Function()? onSecondaryTap,
  ) {
    return Container(
      width: engineSize,
      height: engineSize,
      alignment: Alignment.bottomCenter,
      child: Stand(
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        size: Size(engineSize, engineSize),
        standType: StandType.fromType(widget.itemConfiguration.stand),
        /*CustomPaint(
          painter: StandPainter(engineSize: engineSize, standColor: Theme.of(context).colorScheme.primary.lighten(0.3), standType: widget.itemConfiguration.stand),
        ),*/
      ),
    );
  }

  Widget getStandElement(ThemeData themeData, BoxConstraints constraints) {
    double containerWidth = getWidth(constraints);
    double containerHeight = constraints.maxHeight;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      width: containerWidth,
      height: containerHeight,
      bottom: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: /*space!.item != null
                        ?*/
                _getStands(constraints)
            /*: [
                      if (row!.maxWidthSpaces - row!.maxPosition >= 1.0)
                        Icon(Icons.warning,
                            size: 24 * widget.scaleFactor.value,
                            color: themeData.errorColor)
                    ]*/
            ),
      ),
    );
  }

  List<Widget> _getStands(BoxConstraints constraints) {
    try {
      double engineSize = getEngineSize(constraints);
      //(widget.height?? 0) * (72.5 / 150) - 12;
      //(widget.constraints.heightConstraints().maxHeight * (72.5 / 1260));

      EngineType type = widget.itemConfiguration.engineType;

      switch (type) {
        case EngineType.single:
          return [
            _getStandTappableIcon(engineSize, widget.onStandTap, () {}),
          ];
        case EngineType.double:
          return [
            _getStandTappableIcon(engineSize, widget.onStandTap, () {}),
            _getStandTappableIcon(engineSize, widget.onStandTap, () {}),
          ];

        case EngineType.doubleCustom:
          return [
            _getStandTappableIcon(engineSize, widget.onStandTap, () {}),
            SizedBox(
              width: engineSize / 2,
            ),
            _getStandTappableIcon(engineSize, widget.onStandTap, () {}),
          ];

        default:
          return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Widget getEnginesElement(ThemeData themeData, BoxConstraints constraints) {
    double containerWidth = getWidth(constraints);
    double containerHeight = constraints.maxHeight;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      width: containerWidth,
      height: containerHeight,
      bottom: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: /*space!.item != null
                        ?*/
                _getEngines2(constraints)
            /*: [
                      if (row!.maxWidthSpaces - row!.maxPosition >= 1.0)
                        Icon(Icons.warning,
                            size: 24 * widget.scaleFactor.value,
                            color: themeData.errorColor)
                    ]*/
            ),
      ),
    );
  }

  double getStandHeight(BoxConstraints constraints) {
    double engineSize = getEngineSize(constraints);
    double standHeight = StandState.standHeight(Size(engineSize, engineSize),
        StandType.fromType(widget.itemConfiguration.stand));
    standHeight = StandType.fromType(widget.itemConfiguration.stand) ==
            StandType.notVisible
        ? 0
        : standHeight;

    return standHeight;
  }

  Widget getItemElement(ThemeData themeData, BoxConstraints constraints) {
    double containerWidth = getWidth(constraints);
    double containerHeight = getItemHeight(constraints);

    double standHeight = getStandHeight(constraints);

    //containerHeight=containerHeight+standHeight;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      width: containerWidth,
      height: getHeightSpaces(constraints) > 1.0
          ? containerHeight - standHeight
          : containerHeight,
      bottom: standHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
                width: 0,
                color:
                /* widget.space.isNotEmpty && widget.space.item!.color != null
                    ? Color(widget.space.item!.color!)
                    :*/
                Theme.of(context).colorScheme.secondary),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: /*widget.space.isNotEmpty && widget.space.item!.color != null
                ? Color.alphaBlend(Color(widget.space.item!.color!),
                Theme.of(context).colorScheme.secondary.withAlpha(50))
                .withAlpha(70)
                : */
            getHeightSpaces(constraints) > 1
                ? Color.alphaBlend(Colors.red.withAlpha(100),
                Theme.of(context).colorScheme.secondary.withAlpha(50))
                : Theme.of(context).colorScheme.secondary.withAlpha(50),
            /*widget.itemConfiguration.heightSpaces > 1
                    ? Color.alphaBlend(Colors.red.withAlpha(100),
                        Theme.of(context).colorScheme.secondary.withAlpha(50))
                    : Theme.of(context).colorScheme.secondary.withAlpha(50),*/
          ),
          duration: const Duration(milliseconds: 500),
          height: containerHeight < 0 ? 0 : containerHeight,
          width: containerWidth < 0 ? 0 : containerWidth,
          child: RotatedBox(
            quarterTurns: 1,
            child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    "articolo",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget getDrawer(ThemeData themeData, BoxConstraints constraints) {
    double containerWidth = getWidth(constraints);
    double containerHeight = getDrawerHeight(constraints);

    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: containerWidth,
        height: containerHeight,
        decoration: BoxDecoration(
            color: getHeightSpaces(constraints) > 1
                ? Theme.of(context).colorScheme.primary.lighten().withAlpha(50)
                : null),
        /*BoxDecoration(
            color: widget.itemConfiguration.heightSpaces > 1
                ? Theme.of(context).colorScheme.primary.lighten().withAlpha(100)
                : null),*/
        child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              "cassetto",
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
            )),
      ),
    );
  }

/*
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
                space!.sampleItem,
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
*/

  Widget getDottedBorder(ThemeData themeData, BoxConstraints constraints) {
    return Positioned(
        bottom: 0,
        child: DottedBorder(
          padding: const EdgeInsets.all(0),
          strokeWidth: 1,
          color: /*space!.item != null
                  ?*/
              themeData.colorScheme.primary,
          child: SizedBox(
            width: getWidth(constraints),
            height: getHeight(constraints),
          ),
        ));
  }

  Widget getHeightQuota(ThemeData themeData, BoxConstraints constraints) {
    debugPrint(
        "${((constraints.maxWidth - getWidth(constraints)) / 2) - (getWidth(constraints) / 2)}");

    double standHeight = getStandHeight(constraints);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      left: ((constraints.maxWidth - getWidth(constraints)) / 2) - quotaHeight,
      bottom: standHeight,
      height: getHeight(constraints),
      width: quotaHeight + 28,
      child: Stack(alignment: Alignment.center, children: [
        ///barra orizzontale superiore
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          left: 0,
          top: getHeight(constraints) -
              (getItemHeight(constraints) -
                  (getHeightSpaces(constraints) > 1.0 ? standHeight : 0)),
          width: quotaHeight + 18,
          height: 0,
          child: const Divider(
            height: 0.3,
          ),
        ),

        ///barra verticale
        Positioned(
          bottom: 0,
          height: getItemHeight(constraints) -
              (getHeightSpaces(constraints) > 1.0 ? standHeight : 0),
          width: quotaHeight,
          left: 0,
          child: Stack(
            children: [
              const VerticalDivider(
                width: 0.3,
              ),
              Align(
                  alignment: Alignment.center,
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Tooltip(
                        message:
                            'Spazi per cassetti occupati. 1.0 corrisponde all\'altezza di un cassetto',
                        child: Text(
                          /*"A.: ${widget.itemConfiguration.heightSpaces}"*/
                          "A.: ${getHeightSpaces(constraints).toStringAsFixed(1)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 10),
                        ),
                      ))),
            ],
          ),
        ),
/*
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  left: 0,
top: 0,
width: getItemHeight(constraints),
                  child: RotatedBox(quarterTurns: 3,child: Text("A.: ${widget.itemConfiguration.heightSpaces}", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)))),*/

        ///barra orizzontale inferiore
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          left: 0,
          bottom: 0,
          width: quotaHeight + 18,
          height: 0,
          child: const Divider(height: 0.3),
        ),
      ]),
    );
  }

  Widget getWidthQuota(ThemeData themeData, BoxConstraints constraints) {
    return Positioned(
        top: 0,
        height: quotaHeight,
        width: getWidth(constraints),
        child: SizedBox(
            width: getWidth(constraints),
            height: getHeight(constraints),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  width: 1,
                  height: quotaHeight,
                  child: const VerticalDivider(
                    width: 0.3,
                  ),
                ),
                Positioned(
                  top: 0,
                  width: getWidth(constraints),
                  height: quotaHeight,
                  child: Stack(
                    children: [
                      const Divider(
                        height: 0.3,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Tooltip(
                            message:
                                'Spazi per selezione occupati. 1.0 corrisponde alla larghezza di una selezione',
                            child: Text(
                              "L.: ${widget.itemConfiguration.widthSpaces}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 10),
                            ),
                          )),
                    ],
                  ),
                ),
                Positioned(
                    right: 0,
                    width: 1,
                    height: quotaHeight,
                    child: const VerticalDivider(
                      width: 0.3,
                    )),
              ],
            )));
  }

  List<Widget> getElements(ThemeData themeData, BoxConstraints constraints) {
    return <Widget>[
      getDottedBorder(themeData, constraints),
      getDrawer(themeData, constraints),
      getItemElement(themeData, constraints),
      getEnginesElement(themeData, constraints),

      if (widget.onStandTap != null) getStandElement(themeData, constraints),

      if (widget.showQuotes) getWidthQuota(themeData, constraints),
      if (widget.showQuotes) getHeightQuota(themeData, constraints),
      if (widget.showInfoElements) getNotesElements(themeData, constraints),
      //getDeleteButton(themeData),
    ];
  }

/*
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
*/

  double leftEngineTurns = 0;
  double rightEngineTurns = 0;

  int engineRotationAnimationTime = 350;

  Widget getLeftEngine(double engineSize) {
    double degrees = 360 * widget.itemConfiguration.leftEngineRotation;

    return AnimatedContainer(
      width: engineSize,
      height: engineSize,
      duration: const Duration(milliseconds: 500),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scaleX: -1,
            child: AnimatedRotation(
                turns: widget.itemConfiguration.leftEngineRotation,
                duration: Duration(milliseconds: engineRotationAnimationTime),
                child: _getEngineTappableIcon(engineSize,
                    widget.onLeftEngineTap, widget.onLeftEngineCancelTap)),
          ),
          if (widget.showEngineDegrees)
            IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${degrees.abs().toStringAsFixed(0)}°",
                  style: itemValueTextStyle(context: context),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget getRightEngine(double engineSize) {
    double degrees = 360 * widget.itemConfiguration.rightEngineRotation;

    return AnimatedContainer(
      width: engineSize,
      height: engineSize,
      duration: const Duration(milliseconds: 500),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scaleX: 1,
            child: AnimatedRotation(
                turns: widget.itemConfiguration.rightEngineRotation,
                duration: Duration(milliseconds: engineRotationAnimationTime),
                child: _getEngineTappableIcon(engineSize,
                    widget.onRightEngineTap, widget.onRightEngineCancelTap)),
          ),
          if (widget.showEngineDegrees)
            IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${degrees.abs().toStringAsFixed(0)}°",
                  style: itemValueTextStyle(context: context),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _getEngineTappableIcon(
    double engineSize,
    void Function()? onTap,
    void Function()? onSecondaryTap,
  ) {
    return Container(
        //  duration: const Duration(milliseconds: 500),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        width: 20,
        height: 20,
        child: InkWell(
          onTap: onTap,
          onLongPress: onSecondaryTap,
          customBorder: const CircleBorder(),
          child: CustomPaint(
            painter: EnginePainter(
                engineSize: engineSize,
                engineColor: Theme.of(context).colorScheme.primary),
          ),
        ));
  }

  double getEngineSize(BoxConstraints constraints) {
    double drawerHeight = getDrawerHeight(constraints);

    ///proporzione tra l'altezza effettiva e quella disponibile (constraints.maxHeight)
    double proportion =
        drawerHeight / widget.vmc.vmcPhysicsConfiguration!.drawerHeight;

    ///contentWidth è la larghezza di un motore
    double engineSize =
        (widget.vmc.vmcPhysicsConfiguration!.contentWidth * proportion) - 12;
    if (engineSize < 12) {
      engineSize = 12;
    }
    return engineSize;
  }

  List<Widget> _getEngines2(BoxConstraints constraints) {
    try {
      double engineSize = getEngineSize(constraints);
      //(widget.height?? 0) * (72.5 / 150) - 12;
      //(widget.constraints.heightConstraints().maxHeight * (72.5 / 1260));

      EngineType type = widget.itemConfiguration.engineType;

      switch (type) {
        case EngineType.single:
          return [
            getLeftEngine(engineSize),
          ];
        case EngineType.double:
          return [
            getLeftEngine(engineSize),
            getRightEngine(engineSize),
          ];

        case EngineType.doubleCustom:
          return [
            getLeftEngine(engineSize),
            SizedBox(
              width: engineSize / 2,
            ),
            getRightEngine(engineSize),
          ];

        default:
          return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

/*  BorderRadius? _getContainerRadius(index, spaceIndex) {
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
    double height = (space!.itemConfiguration.heightSpaces);

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
    return space!.sampleItem != null
        ? space!.itemConfiguration!.widthSpaces *
        ((widget.constraints.heightConstraints().maxHeight *
            widget.scaleFactor.value *
            (widget.proportion)) /
            (widget.vmc.vmcConfiguration?.maxRows ?? 8))
        : ((widget.constraints.heightConstraints().maxHeight *
        widget.scaleFactor.value *
        (widget.proportion)) /
        (widget.vmc.vmcConfiguration?.maxRows ?? 8) *
        space!.widthSpaces!);
  }*/
}
