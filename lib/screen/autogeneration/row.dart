import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/screen/autogeneration/space_item.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RowItem extends StatefulWidget {
  const RowItem(
      {this.duration,
      this.curve,
      required this.parentKey,
      this.onDragEnd,
      this.onDragUpdate,
      this.onDraggableCanceled,
      this.onDragStarted,
      this.onDragDown,
      required this.scaleFactor,
      this.showRealDimension,
      this.onItemTap,
      this.canCloseItems = false,
      this.onClose,
      this.highlightSpace,
      this.highlightItem,
      this.newSpaceCandidate,
      this.proportion = (670 / 1260),
      this.candidate,
      this.candidateAdded = false,
      required this.vmcToUse,
      required this.rowIndex,
      required this.constraints,
      Key? key})
      : super(key: key);

  final int rowIndex;
  final BoxConstraints constraints;
  final Vmc vmcToUse;
  final Space? candidate;
  final bool candidateAdded;
  final double proportion;
  final GlobalKey parentKey;
  final Curve? curve;
  final Duration? duration;
  final Function(Space space, DraggableDetails details)? onDragEnd;
  final Function(Space space, DragUpdateDetails details)? onDragUpdate;
  final Function(Space space, Velocity velocity, Offset offset)?
      onDraggableCanceled;
  final Function(Space space, Offset offset)? onDragStarted;
  final Function(Space space, Offset offset)? onDragDown;
  final Function(Space space, int rowIndex, int spaceIndex)? onItemTap;
  final Function(Space space, int rowIndex, int spaceIndex)? onClose;
  final bool canCloseItems;
  final ValueNotifier<double> scaleFactor;
  final ValueNotifier<bool>? showRealDimension;
  final Space? highlightSpace;
  final VmcItem? highlightItem;
  final Space? newSpaceCandidate;

  @override
  State<StatefulWidget> createState() => RowItemState();
}

class RowItemState extends State<RowItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        ..._getRowSpaces(widget.rowIndex, widget.vmcToUse),
      ],
    );
  }

  List<Widget> _getRowSpaces(int rowIndex, Vmc vmcToUse) {
    double widthSingle = getWidthSingle(vmcToUse);
    List<Space>? spaces = vmcToUse.rows?[rowIndex].spaces;
    //Offset offset = box?.globalToLocal(currentDragOffset) ?? const Offset(0, 0);
    //offset=Offset(offset.dx-_dragPointerOffset.value.dx,offset.dy-_dragPointerOffset.value.dy);

    /*print("drag condition: ${candidate?.id ?? -1} (candidate!=null AND candidate!.id == spaces![spaceIndex].id AND isOnDrag) ${ (candidate!=null)}"
        "isOnDrag value $isOnDrag)}");*/
    debugPrint(
        "RowPosition rowIndex(${rowIndex.toString()}): ${_getRowPosition(vmcToUse, rowIndex)}");
    return List.generate(
        spaces?.length ?? 0,
        (spaceIndex) => SpaceItem(
              //key: ValueKey(spaces![spaceIndex]),
              visible: (widget.candidate != null &&
                      widget.candidate!.id == spaces![spaceIndex].id &&
                      widget.candidate!.rowIndex ==
                          spaces[spaceIndex].rowIndex &&
                      widget.candidateAdded)
                  ? false
                  : true,
              parentKey: widget.parentKey,
              curve: widget.curve ?? Curves.linear,
              left:
                  /*  (candidate != null &&
                  candidate!.id == spaces[spaceIndex].id &&
                  candidate!.rowIndex == spaces[spaceIndex].rowIndex &&
                  isOnDrag) ? offset.dx* : */
                  vmcToUse.rows![rowIndex].spaces[spaceIndex].visible
                      ? ((spaces![spaceIndex].position ?? 0) * widthSingle) +
                          _getRowHeaderWidth(vmcToUse, rowIndex)
                      : -500,
              top:
                  /*(candidate != null &&
                  candidate!.id == spaces[spaceIndex].id &&
                  candidate!.rowIndex == spaces[spaceIndex].rowIndex &&
                  isOnDrag) ? offset.dy :*/
                  _getRowPosition(vmcToUse, rowIndex),
              width: widthSingle * spaces![spaceIndex].currentWidthSpaces,
              height: getRowHeight(vmcToUse, rowIndex),
              duration: widget.duration != null
                  ? Duration(
                      milliseconds: widget.duration!.inMilliseconds +
                          Random().nextInt(1000))
                  : Duration.zero,
              onDragEnd: (details) {
                widget.onDragEnd?.call(spaces[spaceIndex], details);
              },
              onDraggableCanceled: (velocity, offset) {
                widget.onDraggableCanceled
                    ?.call(spaces[spaceIndex], velocity, offset);
                debugPrint("onDraggableCanceled");
              },
              onDragUpdate: (details) {
                widget.onDragUpdate?.call(spaces[spaceIndex], details);
              },
              onDragStarted: (space, offset) {
                debugPrint(
                    "onDragStarted: ${space?.rowIndex} ${space?.position}");
                widget.onDragStarted?.call(space!, offset);
              },
              onDragDown: (offset) {
                widget.onDragDown?.call(spaces[spaceIndex], offset);
              },
              onTap: (space, rowIndex, spaceIndex) {
                widget.onItemTap?.call(space, rowIndex, spaceIndex);
              },
              canClose: widget.canCloseItems,
          onClose: (VmcItem? item, int rowIndex, int spaceIndex) {
                widget.onClose?.call(spaces[spaceIndex], rowIndex, spaceIndex);
              },
              rowIndex: rowIndex,
              spaceIndex: spaceIndex,
              space: /*candidate.isNotEmpty ? candidate[0]! : */ vmcToUse
                  .rows![rowIndex].spaces[spaceIndex],
              scaleFactor: widget.scaleFactor,
              showRealDimension: widget.showRealDimension,
              constraints: widget.constraints,
              vmc: vmcToUse,
              selected: (widget.highlightSpace != null &&
                      widget.highlightSpace == spaces[spaceIndex])
                  ? true
                  : false,
              highlight: (spaces[spaceIndex].item != null &&
                      widget.highlightItem != null &&
                      widget.highlightItem == spaces[spaceIndex].item) ||
                  (widget.newSpaceCandidate != null &&
                      widget.newSpaceCandidate!.position ==
                          spaces[spaceIndex].position &&
                      widget.newSpaceCandidate!.rowIndex ==
                          spaces[spaceIndex].rowIndex),
              highlightColor: widget.newSpaceCandidate != null &&
                      widget.newSpaceCandidate!.position ==
                          spaces[spaceIndex].position &&
                      widget.newSpaceCandidate!.rowIndex ==
                          spaces[spaceIndex].rowIndex
                  ? Colors.green
                  : null,
            ));
  }

  double getWidthSingle(Vmc vmcToUse) {
/*    double larghezzaBase =
        (widget.constraints.heightConstraints().maxHeight / vmc!.rows!.length) *
            (670 / 1260);
    return larghezzaBase;*/
    return ((widget.constraints.heightConstraints().maxHeight *
            widget.scaleFactor.value *
            (widget.proportion)) /
        (vmcToUse.vmcConfiguration?.maxWidthSpaces ?? 1));
  }

  double _getRowHeaderWidth(Vmc vmcToUse, int rowIndex) {
    return 40;
  }

  double _getRowPosition(Vmc vmcToUse, int rowIndex) {
    double position = 0;
    if (vmcToUse.rows != null) {
      //debugPrint("rowIndex: ${rowIndex.toString()} : ${getRowHeight(vmcToUse,  rowIndex)}");
      double rowHeight = 0;
      //debugPrint("calcolo rowHeight per rowIndex: ${rowIndex.toString()}");
      for (int index = 0; index < rowIndex; index++) {
        rowHeight += getRowHeight(vmcToUse, index);
        //debugPrint("index: ${index} - ${getRowHeight(vmcToUse,  index)}");

      }
      //debugPrint("rowHeight calcolato: ${rowHeight.toString()}");
      return rowHeight;
    }
    return position;
  }

  double getRowHeight(Vmc vmcToUse, int rowIndex) {
    return vmcToUse.getRowHeight(widget.constraints, rowIndex,
        showRealDimension: widget.showRealDimension?.value ?? false);
  }
}
