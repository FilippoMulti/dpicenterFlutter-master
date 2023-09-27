import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'moderation_response_categories_api.dart';
import 'moderation_response_category_scores_api.dart';

part 'moderation_response_result_api.g.dart';

@JsonSerializable()
@CopyWith()
class ModerationResponseResultApi extends Equatable implements JsonPayload {
  final bool flagged;
  final ModerationResponseCategoriesApi? categories;
  final ModerationResponseCategoryScoresApi? category_scores;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ModerationResponseResultApi({
    this.flagged = false,
    this.categories,
    this.category_scores,
    this.json,
  });

  factory ModerationResponseResultApi.fromJson(Map<String, dynamic> json) {
    return _$ModerationResponseResultApiFromJson(json);
  }

  static ModerationResponseResultApi fromJsonModel(Map<String, dynamic> json) =>
      ModerationResponseResultApi.fromJson(json);

  Map<String, dynamic> toJson() => _$ModerationResponseResultApiToJson(this);

  @override
  List<Object?> get props => [flagged, categories, category_scores];
}
