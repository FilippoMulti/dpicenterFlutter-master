import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intervention_cause.g.dart';

@JsonSerializable()
@CopyWith()
class InterventionCause extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  final int? interventionCauseId;
  final String? cause;

  const InterventionCause({this.interventionCauseId, this.cause, this.json});

  factory InterventionCause.fromJson(Map<String, dynamic> json) {
    var result = _$InterventionCauseFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$InterventionCauseToJson(this);

  @override
  List<Object?> get props => [interventionCauseId, cause];

  static InterventionCause fromJsonModel(Map<String, dynamic> json) =>
      InterventionCause.fromJson(json);
}
