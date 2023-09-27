import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/vmc_production_category.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'vmc_production_field.g.dart';

@JsonSerializable()
@CopyWith()
class VmcProductionField extends Equatable implements JsonPayload, Comparable {
  final int? vmcProductionFieldId;
  final String? name;
  final String? description;
  final String? vmcProductionCategoryCode;
  final VmcProductionCategory? category;
  final int? type;
  final String? params;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcProductionField({
    this.vmcProductionFieldId,
    this.name,
    this.description,
    this.vmcProductionCategoryCode,
    this.category,
    this.type,
    this.params,
    this.json,
  });

  factory VmcProductionField.fromJson(Map<String, dynamic> json) {
    var result = _$VmcProductionFieldFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  factory VmcProductionField.fromMachineProduction(MachineProduction item) {
    return VmcProductionField(
        vmcProductionFieldId: 0,
        name: item.name,
        description: item.description,
        vmcProductionCategoryCode: item.categoryCode,
        category: VmcProductionCategory(
            vmcProductionCategoryCode: item.categoryCode,
            name: item.categoryName,
            color: item.categoryColor),
        type: item.type,
        params: item.params);
  }

  Map<String, dynamic> toJson() => _$VmcProductionFieldToJson(this);

  static VmcProductionField fromJsonModel(Map<String, dynamic> json) =>
      VmcProductionField.fromJson(json);

  @override
  String toString() {
    return '$description';
  }

  @override
  List<Object?> get props => [
        vmcProductionFieldId,
        name,
        description,
        vmcProductionCategoryCode,
        type,
        params,
      ];

  @override
  int compareTo(other) {
    if (other is VmcProductionField) {
      return description?.compareTo(other.description ?? '') ?? -1;
    }
    return -1;
  }
}
