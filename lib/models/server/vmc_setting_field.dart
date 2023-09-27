import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'vmc_setting_field.g.dart';

@JsonSerializable()
@CopyWith()
class VmcSettingField extends Equatable implements JsonPayload, Comparable {
  final int? vmcSettingFieldId;
  final String? name;
  final String? description;
  final String? vmcSettingCategoryCode;
  final VmcSettingCategory? category;
  final int? type;
  final String? params;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcSettingField({
    this.vmcSettingFieldId,
    this.name,
    this.description,
    this.vmcSettingCategoryCode,
    this.category,
    this.type,
    this.params,
    this.json,
  });

  factory VmcSettingField.fromJson(Map<String, dynamic> json) {
    var result = _$VmcSettingFieldFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  factory VmcSettingField.fromMachineSetting(MachineSetting item) {
    return VmcSettingField(
        vmcSettingFieldId: 0,
        name: item.name,
        description: item.description,
        vmcSettingCategoryCode: item.categoryCode,
        category: VmcSettingCategory(
            vmcSettingCategoryCode: item.categoryCode,
            name: item.categoryName,
            color: item.categoryColor),
        type: item.type,
        params: item.params);
  }

  Map<String, dynamic> toJson() => _$VmcSettingFieldToJson(this);

  static VmcSettingField fromJsonModel(Map<String, dynamic> json) =>
      VmcSettingField.fromJson(json);

  @override
  String toString() {
    return '$description';
  }

  @override
  List<Object?> get props => [
        vmcSettingFieldId,
        name,
        description,
        vmcSettingCategoryCode,
        category,
        type,
      ];

  @override
  int compareTo(other) {
    if (other is VmcSettingField) {
      return description?.compareTo(other.description ?? '') ?? -1;
    }
    return -1;
  }
}
