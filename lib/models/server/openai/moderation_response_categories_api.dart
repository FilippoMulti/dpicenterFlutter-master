import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'moderation_response_categories_api.g.dart';

@JsonSerializable()
@CopyWith()
class ModerationResponseCategoriesApi extends Equatable implements JsonPayload {
  final bool hate;
  final bool hateThreatening;
  final bool selfHarm;
  final bool sexual;
  final bool sexualMinors;
  final bool violence;
  final bool violenceGraphic;
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ModerationResponseCategoriesApi({
    this.hate = false,
    this.hateThreatening = false,
    this.selfHarm = false,
    this.sexual = false,
    this.sexualMinors = false,
    this.violence = false,
    this.violenceGraphic = false,
    this.json,
  });

  factory ModerationResponseCategoriesApi.fromJson(Map<String, dynamic> json) {
    return _$ModerationResponseCategoriesApiFromJson(json);
  }

  static ModerationResponseCategoriesApi fromJsonModel(
          Map<String, dynamic> json) =>
      ModerationResponseCategoriesApi.fromJson(json);

  Map<String, dynamic> toJson() =>
      _$ModerationResponseCategoriesApiToJson(this);

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
