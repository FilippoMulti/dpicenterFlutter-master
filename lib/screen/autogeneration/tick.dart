import 'package:dotted_border/dotted_border.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:flutter/material.dart';

class Tick extends StatelessWidget {
  const Tick(
      {required this.space,
      required this.vmc,
      required this.constraints,
      required this.scaleFactor,
      required this.rowIndex,
      required this.spaceIndex,
      this.proportion = (670 / 1260),
      Key? key})
      : super(key: key);
  final BoxConstraints constraints;
  final ValueNotifier<double> scaleFactor;

  final int rowIndex;
  final int spaceIndex;
  final Space space;
  final Vmc vmc;
  final double proportion;

  @override
  Widget build(BuildContext context) {
    //VmcRow row = vmc.rows![rowIndex];

    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      waitDuration: const Duration(milliseconds: 500),
      message: space.item != null
          ? '${space.item!.item.code!}\r\n${space.item!.item.description}'
          : 'Locazione vuota',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _getContainerRadius(rowIndex, spaceIndex),
          //border: Border.all(color: Colors.transparent)
          //(index==0 || index==widget.vmc.rows!.length-1) && (spaceIndex==0 || widget.vmc.rows![index].spaces[spaceIndex]==widget.vmc.rows![index].spaces.last) ? const BorderRadius.vertical(top: Radius.circular(20)) : null,
        ),
        height: _getRowHeight(-1),
        width: _getContainerWidth(),
        child: DottedBorder(
          strokeWidth: space.item != null ? 0 : 0.5,
          color: Theme.of(context).colorScheme.primary,
          child: Container(),
        ),
      ),
    );
  }

  BorderRadius? _getContainerRadius(index, spaceIndex) {
    if (index == 0 && spaceIndex == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(4));
    }
    if (index == 0 &&
        vmc.rows![index].spaces[spaceIndex] == vmc.rows![index].spaces.last) {
      return const BorderRadius.only(topRight: Radius.circular(4));
    }
    if (index == vmc.rows!.length - 1 && spaceIndex == 0) {
      return const BorderRadius.only(bottomLeft: Radius.circular(4));
    }
    if (index == vmc.rows!.length - 1 &&
        vmc.rows![index].spaces[spaceIndex] == vmc.rows![index].spaces.last) {
      return const BorderRadius.only(bottomRight: Radius.circular(4));
    }
    return null;
  }

  double _getRowHeight(index) {
    double rowSpace = (constraints.heightConstraints().maxHeight *
        scaleFactor.value /
        (vmc.rows?.length ?? 1.0));

    if (index == -1) {
      return rowSpace;
    }

    return rowSpace;
  }

  double _getContainerWidth() {
    return space.item != null
        ? space.item!.itemConfiguration!.widthSpaces *
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


