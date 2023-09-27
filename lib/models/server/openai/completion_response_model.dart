import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/openai/data_frame_result.dart';
import 'package:dpicenter/models/server/openai/moderation_response_model_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'moderation_response_result_api.dart';

part 'completion_response_model.g.dart';

@JsonSerializable()
@CopyWith()
class CompletionResponseModel extends Equatable implements JsonPayload {
  final int completionInputId;
  final String data;
  final ModerationResponseModelApi inputModerationResult;
  final ModerationResponseModelApi outputModerationResult;
  final List<DataFrameResult>? semanticSearchResult;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const CompletionResponseModel({
    this.completionInputId = 0,
    this.data = '',
    this.inputModerationResult = const ModerationResponseModelApi(),
    this.outputModerationResult = const ModerationResponseModelApi(),
    this.semanticSearchResult,
    this.json,
  });

  factory CompletionResponseModel.fromJson(Map<String, dynamic> json) {
    return _$CompletionResponseModelFromJson(json);
  }

  static CompletionResponseModel fromJsonModel(Map<String, dynamic> json) =>
      CompletionResponseModel.fromJson(json);

  Map<String, dynamic> toJson() => _$CompletionResponseModelToJson(this);

  @override
  List<Object?> get props => [
        completionInputId,
        data,
        inputModerationResult,
        outputModerationResult,
        semanticSearchResult
      ];
}
