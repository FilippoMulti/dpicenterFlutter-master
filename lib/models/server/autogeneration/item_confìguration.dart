import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_note.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_confìguration.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class SampleItemConfiguration extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int? sampleItemConfigurationId;

  final double widthSpaces;
  final double depthSpaces;
  final double heightSpaces;

  ///aletta
  final bool flap;

  ///imbustare
  final PackageType packaging;

  ///note
  final List<SampleItemNote> notes;

  ///utilizza o meno un blister per la distribuzione
  final BlisterType blisterType;
  final BlisterColor blisterColor;

  final int vmcId;

  final Vmc vmc;

  ///altezza massima in cui posizionare il prodotto
  final int? maxRow;

  ///altezza minima in cui posizionare il prodotto
  final int? minRow;

  ///posizione orizzontale minima in cui posizionare il prodotto
  final double? minPos;

  ///posizione orizzontale massima in cui posizionare il prodotto
  final double? maxPos;

  final bool photoCell;
  final EngineType engineType;

  ///fasatura motore di sinistra
  final double leftEngineRotation;

  ///fasatura motore di destra
  final double rightEngineRotation;

  ///utilizzo o meno di un alzatina. 0 disabilitato, 1 alzatina bassa e stretta, 2 alzatina alta e larga
  final int stand;

  const SampleItemConfiguration(
      {required this.widthSpaces,
      required this.depthSpaces,
      required this.heightSpaces,
      this.leftEngineRotation = 0,
      this.rightEngineRotation = 0,
      this.sampleItemConfigurationId,
      this.photoCell = true,
      this.engineType = EngineType.single,
      this.blisterType = BlisterType.medium,
      this.blisterColor = BlisterColor.black,
      this.packaging = PackageType.no,
      this.flap = false,
      this.notes = const <SampleItemNote>[],
      this.json,
      this.maxRow,
      this.minRow,
      this.minPos,
      this.maxPos,
      required this.vmcId,
      this.stand = 0,
      required this.vmc});

  factory SampleItemConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$SampleItemConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$SampleItemConfigurationToJson(this);

  static SampleItemConfiguration fromJsonModel(Map<String, dynamic> json) =>
      SampleItemConfiguration.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props =>
      [
        widthSpaces,
        depthSpaces,
        heightSpaces,
        photoCell,
        engineType,
        minRow,
        maxRow,
        minPos,
        maxPos,
        sampleItemConfigurationId,
        flap,
        packaging,
        blisterType,
        blisterColor,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  static String engineTypeToString(EngineType type) {
    String text = '';
    switch (type) {
      case EngineType.single:
        text = 'Motore singolo';
        break;
      case EngineType.double:
        text = 'Motore doppio';
        break;
      case EngineType.doubleCustom:
        text = 'Motore doppio largo';
        break;
      case EngineType.other:
        text = 'Altro';
        break;
    }
    return text;
  }

  static Widget engineTypeToIcon(EngineType type) {
    switch (type) {
      case EngineType.double:
        return SizedBox(
          width: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                  scaleX: -1, child: const Icon(Icons.settings_backup_restore)),
              const Icon(Icons.settings_backup_restore),
            ],
          ),
        );

      case EngineType.doubleCustom:
        return SizedBox(
            width: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.scale(
                    scaleX: -1,
                    child: const Icon(Icons.settings_backup_restore)),
                const Icon(Icons.settings_backup_restore),
              ],
            ));
      case EngineType.other:
        return SizedBox(
            width: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.question_mark_outlined),
              ],
            ));

      case EngineType.single:
      default:
        return SizedBox(
          width: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                  scaleX: -1, child: const Icon(Icons.settings_backup_restore)),
            ],
          ),
        );
    }
    return const SizedBox();
  }

  static Widget engineTypeToRowItem(EngineType type) {
    return Row(
      children: [
        SampleItemConfiguration.engineTypeToIcon(type),
        const SizedBox(
          width: 8,
        ),
        Text(SampleItemConfiguration.engineTypeToString(type)),
      ],
    );
  }
}

enum EngineType {
  @JsonValue(0)
  single,
  @JsonValue(1)
  double,
  @JsonValue(2)
  doubleCustom,
  @JsonValue(3)
  other,
}

enum BlisterType {
  @JsonValue(0)
  tiny,
  @JsonValue(1)
  medium,
  @JsonValue(2)
  large,
  @JsonValue(3)
  other,
}

enum BlisterColor {
  @JsonValue(0)
  transparent,
  @JsonValue(1)
  black,
  @JsonValue(2)
  other,
}

enum PackageType {
  no(0),
  envelop(1),
  blister(2),
  reverse(3);

  final int type;

  const PackageType(this.type);

  factory PackageType.fromType(int type) {
    return values.firstWhere((e) => e.type == type);
  }

  static Widget toRowItem(PackageType type) {
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
        return 'Imbustare';
      case 2:
        return 'Blister';
      case 3:
        return 'Rovescia prodotto';

      case 0:
      default:
        return 'Non necessario';
    }
  }

  Icon toIcon({Color? color}) {
    return Icon(toIconData(), color: color);
  }

  IconData toIconData() {
    switch (type) {
      case 1: //imbustare
        return Icons.move_to_inbox;
      case 2: //blister
        return Icons.inventory_2;
      case 3: //rovesciare
        return Icons.published_with_changes;

      case 0: //non necessario
      default:
        return Icons.block;
    }
  }
}