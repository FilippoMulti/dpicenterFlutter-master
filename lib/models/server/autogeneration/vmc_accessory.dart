import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_accessory.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcAccessory extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcAccessoryId;
  final int vmcId;
  final int itemId;

  const VmcAccessory(
      {required this.vmcAccessoryId,
      required this.vmcId,
      required this.itemId,
      this.json});

  factory VmcAccessory.fromJson(Map<String, dynamic> json) {
    var result = _$VmcAccessoryFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcAccessoryToJson(this);

  static VmcAccessory fromJsonModel(Map<String, dynamic> json) =>
      VmcAccessory.fromJson(json);

  @override
  List<Object?> get props => [
        vmcAccessoryId,
        vmcId,
        itemId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
