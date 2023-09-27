import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_selection.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcSelection extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcSelectionId;
  final int vmcId;
  final int steps;
  final bool singleEngine;
  final bool doubleEngine;
  final int itemId;

  const VmcSelection(
      {required this.itemId,
      required this.vmcSelectionId,
      required this.vmcId,
      this.steps = 9,
      this.singleEngine = true,
      this.doubleEngine = true,
      this.json});

  factory VmcSelection.fromJson(Map<String, dynamic> json) {
    var result = _$VmcSelectionFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcSelectionToJson(this);

  static VmcSelection fromJsonModel(Map<String, dynamic> json) =>
      VmcSelection.fromJson(json);

  @override
  List<Object?> get props => [
        vmcSelectionId,
        vmcId,
        singleEngine,
        doubleEngine,
        steps,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
