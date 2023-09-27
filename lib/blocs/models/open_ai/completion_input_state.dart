import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/openai/completion_input.dart';
import 'package:dpicenter/models/server/openai/completion_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'completion_input_state.g.dart';

@JsonSerializable()
@CopyWith()
class CompletionInputState extends Equatable implements JsonPayload {
  final int? completionId;
  final bool inProgress;
  final bool finished;
  final CompletionResponseModel? result;
  final CompletionInput? input;
  final String? question;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const CompletionInputState(
      {this.completionId,
      this.finished = false,
      this.result,
      this.input,
      this.question,
      this.inProgress = false,
      this.json});

  factory CompletionInputState.fromJson(Map<String, dynamic> json) {
    var result = _$CompletionInputStateFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$CompletionInputStateToJson(this);

  static CompletionInput fromJsonModel(Map<String, dynamic> json) =>
      CompletionInput.fromJson(json);

  @override
  List<Object?> get props =>
      [completionId, finished, result, input, question, inProgress];
}
