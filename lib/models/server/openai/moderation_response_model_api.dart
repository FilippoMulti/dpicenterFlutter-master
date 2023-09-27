import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'moderation_response_result_api.dart';

part 'moderation_response_model_api.g.dart';

@JsonSerializable()
@CopyWith()
class ModerationResponseModelApi extends Equatable implements JsonPayload {
  final String id;
  final String model;
  final List<ModerationResponseResultApi> results;
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ModerationResponseModelApi({
    this.id = '',
    this.model = '',
    this.results = const [],
    this.json,
  });

  factory ModerationResponseModelApi.fromJson(Map<String, dynamic> json) {
    return _$ModerationResponseModelApiFromJson(json);
  }

  static ModerationResponseModelApi fromJsonModel(Map<String, dynamic> json) =>
      ModerationResponseModelApi.fromJson(json);

  Map<String, dynamic> toJson() => _$ModerationResponseModelApiToJson(this);

  @override
  List<Object?> get props => [id, model, results];
}
