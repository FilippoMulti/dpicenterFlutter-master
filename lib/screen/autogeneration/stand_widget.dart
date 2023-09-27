import 'package:flutter/material.dart';

class Stand extends StatefulWidget {
  const Stand(
      {this.onTap,
      this.onSecondaryTap,
      this.standType = StandType.mediumTight,
      required this.size,
      Key? key})
      : super(key: key);

  final Size size;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final StandType standType;

  @override
  StandState createState() => StandState();
}

class StandState extends State<Stand> {
  @override
  Widget build(BuildContext context) {
    double standWidth = getStandWidth();
    double standHeight = getStandHeight();

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onSecondaryTap,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: widget.standType == StandType.notVisible
                  ? Colors.transparent
                  : Colors.grey.withAlpha(200),
            ),
            duration: const Duration(milliseconds: 500),
            width: standWidth,
            height: standHeight,
          )
          /*CustomPaint(
              painter: StandPainter(engineSize: engineSize, standColor: Theme.of(context).colorScheme.primary.lighten(0.3), standType: widget.itemConfiguration.stand),
            ),*/
          ),
    );
  }

  double getStandWidth() {
    return standWidth(widget.size, widget.standType);
  }

  ///restituisce il parametro per cui dividere engineSize ed ottenere lo stand della dimensione giusta
  static double standEngineHeightFraction(standType) {
    switch (standType) {
      case StandType.lowerTight:
        return 4;
      case StandType.lowerLarge:
        return 3.8;
      case StandType.mediumTight:
        return 2.8;
      case StandType.mediumLarge:
        return 2.8;
      case StandType.higherTight:
        return 2;
      case StandType.higherLarge:
        return 2;

      default:
        return 1;
    }
  }

  static double standHeight(Size engineSize, StandType standType) {
    switch (standType) {
      case StandType.notVisible:
        return engineSize.height;
      default:
        return engineSize.height / standEngineHeightFraction(standType);
    }
  }

  static double standWidth(Size engineSize, StandType standType) {
    switch (standType) {
      case StandType.lowerTight:
        return engineSize.width / 4;
      case StandType.lowerLarge:
        return engineSize.width / 1.5;
      case StandType.mediumTight:
        return engineSize.width / 4;
      case StandType.mediumLarge:
        return engineSize.width / 1.5;
      case StandType.higherTight:
        return engineSize.width / 4;
      case StandType.higherLarge:
        return engineSize.width / 1.5;
      default:
        return engineSize.width;
    }
  }

  double getStandHeight() {
    return standHeight(widget.size, widget.standType);
  }
}

enum StandType {
  notVisible(0),
  lowerTight(1),
  lowerLarge(2),
  mediumTight(3),
  mediumLarge(4),
  higherTight(5),
  higherLarge(6);

  final int type;

  const StandType(this.type);

  factory StandType.fromType(int type) {
    return values.firstWhere((e) => e.type == type);
  }

  @override
  String toString() {
    switch (type) {
      case 0:
        return 'Non montare';
      case 1:
        return 'Bassa stretta';
      case 2:
        return 'Bassa larga';
      case 3:
        return 'Media stretta';
      case 4:
        return 'Media larga';
      case 5:
        return 'Alta stretta';
      case 6:
        return 'Alta larga';
    }
    return 'Non conosciuta';
  }
}
