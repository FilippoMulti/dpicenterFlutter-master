import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'completion_input.g.dart';

@JsonSerializable()
@CopyWith()
class CompletionInput extends Equatable implements JsonPayload {
  final String? text;
  final String engine;
  final int tokens;
  final int completionInputId;
  final double temperature;
  final double presencePenalty;
  final double frequencyPenalty;
  final String? instruction;
  final String? exampleContext;
  final String? example;
  final double thresholdModifier;

  final bool generateCompletion;
  final bool generateSemanticResult;
  final int searchType;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const CompletionInput({
    this.text,
    this.tokens = 2000,
    this.engine =
        "text-davinci-003", //"davinci:ft-multi-tech-2023-01-27-17-31-22", //text-davinci-003
    this.json,
    this.temperature = 0.01,
    this.presencePenalty = 0.1,
    this.frequencyPenalty = 0.1,
    this.instruction,
    this.exampleContext,
    this.example,
    this.generateCompletion = true,
    this.generateSemanticResult = true,
    this.thresholdModifier = 0,
    this.searchType = 0,
    required this.completionInputId,
  });

  factory CompletionInput.fromJson(Map<String, dynamic> json) {
    var result = _$CompletionInputFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$CompletionInputToJson(this);

  static CompletionInput fromJsonModel(Map<String, dynamic> json) =>
      CompletionInput.fromJson(json);

  @override
  List<Object?> get props =>
      [
        text,
        engine,
        tokens,
        completionInputId,
        example,
        exampleContext,
        instruction,
        generateCompletion,
        generateSemanticResult,
        thresholdModifier,
        searchType
      ];
}
