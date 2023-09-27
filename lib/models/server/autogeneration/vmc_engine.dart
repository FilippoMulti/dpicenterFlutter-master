import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_engine.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcEngine extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcEngineId;
  final int vmcId;
  final int itemId;
  final bool single;
  final bool double;

  const VmcEngine(
      {required this.vmcEngineId,
      required this.vmcId,
      required this.itemId,
      this.single = false,
      this.double = false,
      this.json});

  factory VmcEngine.fromJson(Map<String, dynamic> json) {
    var result = _$VmcEngineFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcEngineToJson(this);

  static VmcEngine fromJsonModel(Map<String, dynamic> json) =>
      VmcEngine.fromJson(json);

  @override
  List<Object?> get props => [vmcEngineId, vmcId, itemId, single, double];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
