import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/openai/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'chat_input.g.dart';

@JsonSerializable()
@CopyWith()
class ChatInput extends Equatable implements JsonPayload {
  final List<Message>? messages;
  final String engine;
  final int tokens;
  final int chatInputId;
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

  const ChatInput({
    this.messages,
    this.tokens = 2000,
    this.engine = "gpt-3.5-turbo",
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
    required this.chatInputId,
  });

  factory ChatInput.fromJson(Map<String, dynamic> json) {
    var result = _$ChatInputFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ChatInputToJson(this);

  static ChatInput fromJsonModel(Map<String, dynamic> json) =>
      ChatInput.fromJson(json);

  @override
  List<Object?> get props => [
        messages,
        engine,
        tokens,
        chatInputId,
        example,
        exampleContext,
        instruction,
        generateCompletion,
        generateSemanticResult,
        thresholdModifier,
        searchType
      ];
}
