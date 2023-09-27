import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'vmc_setting_category.g.dart';

@JsonSerializable()
@CopyWith()
class VmcSettingCategory extends Equatable implements JsonPayload, Comparable {
  final String? vmcSettingCategoryCode;
  final String? name;
  final String? color;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcSettingCategory({
    this.vmcSettingCategoryCode,
    this.name,
    this.color,
    this.json,
  });

  factory VmcSettingCategory.fromJson(Map<String, dynamic> json) {
    var result = _$VmcSettingCategoryFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcSettingCategoryToJson(this);

  static VmcSettingCategory fromJsonModel(Map<String, dynamic> json) =>
      VmcSettingCategory.fromJson(json);

  @override
  String toString() {
    return '$name';
  }

  @override
  List<Object?> get props => [
        vmcSettingCategoryCode,
        name,
        color,
      ];

  @override
  int compareTo(other) {
    if (other is VmcSettingCategory) {
      return name?.compareTo(other.name ?? '') ?? -1;
    }
    return -1;
  }
}
