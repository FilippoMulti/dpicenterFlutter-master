import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_configuration.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcConfiguration extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcConfigurationId;

  final int maxRows;
  final int maxWidthSpaces;
  final int tickInSingleSpace;

  ///imposta la rotazione di un singolo motore in senso orario (valore: 0) o antiorario (valore: 1)
  final int singleEngineRotationVerse;

  ///imposta la rotazione del motore di signistra in senso orario (valore: 0) o antiorario (valore: 1), ovviamente il motore di destra avrà la rotazione nel senso opposto
  final int doubleEngineRotationVerse;

  const VmcConfiguration(
      {required this.vmcConfigurationId,
      this.maxRows = 8,
      this.maxWidthSpaces = 9,
      this.tickInSingleSpace = 4,
      this.singleEngineRotationVerse = 0,
      this.doubleEngineRotationVerse = 0,
      this.json});

  factory VmcConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$VmcConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcConfigurationToJson(this);

  static VmcConfiguration fromJsonModel(Map<String, dynamic> json) =>
      VmcConfiguration.fromJson(json);

  @override
  List<Object?> get props => [
        vmcConfigurationId,
        maxRows,
        maxWidthSpaces,
        tickInSingleSpace,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
