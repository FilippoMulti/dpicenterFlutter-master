import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'moderation_response_category_scores_api.g.dart';

@JsonSerializable()
@CopyWith()
class ModerationResponseCategoryScoresApi extends Equatable
    implements JsonPayload {
  final double hate;
  final double hateThreatening;
  final double selfHarm;
  final double sexual;
  final double sexualMinors;
  final double violence;
  final double violenceGraphic;
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ModerationResponseCategoryScoresApi({
    this.hate = 0.0,
    this.hateThreatening = 0.0,
    this.selfHarm = 0.0,
    this.sexual = 0.0,
    this.sexualMinors = 0.0,
    this.violence = 0.0,
    this.violenceGraphic = 0.0,
    this.json,
  });

  factory ModerationResponseCategoryScoresApi.fromJson(
      Map<String, dynamic> json) {
    return _$ModerationResponseCategoryScoresApiFromJson(json);
  }

  static ModerationResponseCategoryScoresApi fromJsonModel(
          Map<String, dynamic> json) =>
      ModerationResponseCategoryScoresApi.fromJson(json);

  Map<String, dynamic> toJson() =>
      _$ModerationResponseCategoryScoresApiToJson(this);

  @override
  List<Object?> get props => [
        hate,
        hateThreatening,
        selfHarm,
        sexual,
        sexualMinors,
        violence,
        violenceGraphic
      ];
}
