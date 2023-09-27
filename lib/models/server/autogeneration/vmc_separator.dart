import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_separator.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcSeparator extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcSeparatorId;
  final int vmcId;
  final int itemId;

  const VmcSeparator(
      {required this.vmcSeparatorId,
      required this.vmcId,
      required this.itemId,
      this.json});

  factory VmcSeparator.fromJson(Map<String, dynamic> json) {
    var result = _$VmcSeparatorFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcSeparatorToJson(this);

  static VmcSeparator fromJsonModel(Map<String, dynamic> json) =>
      VmcSeparator.fromJson(json);

  @override
  List<Object?> get props => [
        vmcSeparatorId,
        vmcId,
        itemId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
