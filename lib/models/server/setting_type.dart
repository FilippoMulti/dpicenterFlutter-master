import 'package:flutter/material.dart';

enum Type {
  textInput(0),
  selection(1),
  upDown(2),
  image(3),
  switchCheck(4),
  fileLoader(5);

  final int typeValue;

  const Type(this.typeValue);

  factory Type.fromType(int type) {
    return values.firstWhere((e) => e.typeValue == type);
  }

  static Widget toRowItem(Type type) {
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
    switch (typeValue) {
      case 1:
        return 'Selezione tra diverse opzioni';
      case 2:
        return 'Selezione di un valore';
      case 3:
        return 'Carica un immagine';
      case 4:
        return 'Interruttore on-off';
      case 5:
        return 'Carica un file';
      case 0:
      default:
        return 'Input testo';
    }
  }

  Icon toIcon({Color? color}) {
    return Icon(toIconData(), color: color);
  }

  IconData toIconData() {
    switch (typeValue) {
      case 1: //selection
        return Icons.arrow_drop_down_circle;
      case 2: //up down
        return Icons.thumbs_up_down;
      case 3: //immagine
        return Icons.image;
      case 4: //switch
        return Icons.switch_left;
      case 5: //file_upload
        return Icons.file_upload;
      case 0: //input testo
      default:
        return Icons.text_fields;
    }
  }
}
