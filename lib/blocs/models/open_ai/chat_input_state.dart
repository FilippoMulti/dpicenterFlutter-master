import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/openai/chat_input.dart';
import 'package:dpicenter/models/server/openai/completion_input.dart';
import 'package:dpicenter/models/server/openai/completion_response_model.dart';
import 'package:dpicenter/models/server/openai/message.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_input_state.g.dart';

@JsonSerializable()
@CopyWith()
class ChatInputState extends Equatable implements JsonPayload {
  final int? chatId;
  final bool inProgress;
  final bool finished;
  final CompletionResponseModel? result;
  final ChatInput? input;
  final List<Message>? question;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ChatInputState(
      {this.chatId,
      this.finished = false,
      this.result,
      this.input,
      this.question,
      this.inProgress = false,
      this.json});

  factory ChatInputState.fromJson(Map<String, dynamic> json) {
    var result = _$ChatInputStateFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ChatInputStateToJson(this);

  static ChatInputState fromJsonModel(Map<String, dynamic> json) =>
      ChatInputState.fromJson(json);

  @override
  List<Object?> get props =>
      [chatId, finished, result, input, question, inProgress];
}
