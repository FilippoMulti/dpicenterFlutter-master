import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_physics_configuration.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcPhysicsConfiguration extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcPhysicsConfigurationId;

  final double vmcWidthMm;
  final double vmcHeightMm;
  final double vmcDepthMm;
  final double drawerHeight;
  final double contentHeight;
  final double contentWidth;

  const VmcPhysicsConfiguration(
      {required this.vmcPhysicsConfigurationId,
        ///larghezza spazio disponibile per cassetti, larghezza cassetto
      this.vmcWidthMm = 670,

        ///altezza spazio disponibile per cassetti
      this.vmcHeightMm = 1260,

        ///profondità cassetto
      this.vmcDepthMm = 540,

        ///altezza cassetto
      this.drawerHeight = 125,

        ///altezza spazio utile prodotto
      this.contentHeight = 115,

        ///larghezza singolo motore, larghezza spazio singolo
      this.contentWidth = 75,
      this.json});

  factory VmcPhysicsConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$VmcPhysicsConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcPhysicsConfigurationToJson(this);

  static VmcPhysicsConfiguration fromJsonModel(Map<String, dynamic> json) =>
      VmcPhysicsConfiguration.fromJson(json);

  @override
  List<Object?> get props =>
      [
        vmcHeightMm,
        vmcPhysicsConfigurationId,
        vmcWidthMm,
        vmcDepthMm,
        drawerHeight,
        contentWidth,
        contentHeight
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
