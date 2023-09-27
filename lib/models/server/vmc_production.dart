import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'vmc_production.g.dart';

@JsonSerializable()
@CopyWith()
class VmcProduction extends Equatable implements JsonPayload, Comparable {
  final int? vmcProductionId;
  final int? vmcProductionFieldId;
  final VmcProductionField? productionField;
  final int? vmcId;
  final Vmc? vmc;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcProduction({
    this.vmcProductionId,
    this.vmcProductionFieldId,
    this.vmcId,
    this.productionField,
    this.vmc,
    this.json,
  });

  factory VmcProduction.fromJson(Map<String, dynamic> json) {
    var result = _$VmcProductionFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcProductionToJson(this);

  static VmcProduction fromJsonModel(Map<String, dynamic> json) =>
      VmcProduction.fromJson(json);

  @override
  List<Object?> get props => [
        vmcProductionFieldId,
        vmcProductionId,
        vmcId,
      ];

  @override
  int compareTo(other) {
    if (other is VmcProduction) {
      return productionField?.description
              ?.compareTo(productionField?.description ?? '') ??
          -1;
    }
    return -1;
  }
}
