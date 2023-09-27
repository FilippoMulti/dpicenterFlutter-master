import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'vmc_production_category.g.dart';

@JsonSerializable()
@CopyWith()
class VmcProductionCategory extends Equatable
    implements JsonPayload, Comparable {
  final String? vmcProductionCategoryCode;
  final String? name;
  final String? color;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcProductionCategory({
    this.vmcProductionCategoryCode,
    this.name,
    this.color,
    this.json,
  });

  factory VmcProductionCategory.fromJson(Map<String, dynamic> json) {
    var result = _$VmcProductionCategoryFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcProductionCategoryToJson(this);

  static VmcProductionCategory fromJsonModel(Map<String, dynamic> json) =>
      VmcProductionCategory.fromJson(json);

  @override
  String toString() {
    return '$name';
  }

  @override
  List<Object?> get props => [
        vmcProductionCategoryCode,
        name,
        color,
      ];

  @override
  int compareTo(other) {
    if (other is VmcProductionCategory) {
      return name?.compareTo(other.name ?? '') ?? -1;
    }
    return -1;
  }
}
