import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/openai/data_frame.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'data_frame_result.g.dart';

@JsonSerializable()
@CopyWith()
class DataFrameResult extends Equatable implements JsonPayload {
  final int? dataframeId;
  final String? question;
  final String? answer;
  final double similarity;
  final String? result;
  final int type;
  final double threshold;
  final String? attachments;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const DataFrameResult({
    this.dataframeId,
    this.question,
    this.answer,
    this.similarity = 0,
    this.result,
    this.type = 0,
    this.threshold = 0.0,
    this.attachments,
    this.json,
  });

  factory DataFrameResult.fromJson(Map<String, dynamic> json) {
    var result = _$DataFrameResultFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$DataFrameResultToJson(this);

  static DataFrameResult fromJsonModel(Map<String, dynamic> json) =>
      DataFrameResult.fromJson(json);

  @override
  List<Object?> get props =>
      [
        dataframeId,
        question,
        answer,
        similarity,
        result,
        type,
        threshold,
        attachments,
      ];

  DataFrame toDataFrame() {
    return DataFrame(id: dataframeId, question: question, answer: answer);
  }
}
