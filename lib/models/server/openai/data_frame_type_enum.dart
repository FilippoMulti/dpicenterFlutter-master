import 'package:flutter/material.dart';

enum DataFrameType {
  doc(0),
  production(1),
  settings(2),
  image(3);

  final int type;

  const DataFrameType(this.type);

  factory DataFrameType.fromType(int type) {
    return values.firstWhere((e) => e.type == type);
  }

  static Widget toRowItem(DataFrameType type) {
    return Row(
      children: [
        type.toIcon(),
        const SizedBox(
          width: 8,
        ),
        Text(type.toString()),
      ],
    );
  }

  @override
  String toString() {
    switch (type) {
      case 1:
        return 'Produzione';
      case 2:
        return 'Impostazioni';
      case 3:
        return 'Immagini';

      case 0:
      default:
        return 'Documento';
    }
  }

  Icon toIcon({Color? color}) {
    return Icon(toIconData(), color: color);
  }

  IconData toIconData() {
    switch (type) {
      case 1: //Produzione
        return Icons.factory;
      case 2: //Impostazioni
        return Icons.settings;
      case 3: //Immagini
        return Icons.image;

      case 0: //Documento
      default:
        return Icons.filter_frames;
    }
  }
}
