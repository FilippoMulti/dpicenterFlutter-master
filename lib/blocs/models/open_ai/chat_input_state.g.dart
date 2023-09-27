// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatInputStateCWProxy {
  ChatInputState chatId(int? chatId);

  ChatInputState finished(bool finished);

  ChatInputState inProgress(bool inProgress);

  ChatInputState input(ChatInput? input);

  ChatInputState json(dynamic json);

  ChatInputState question(List<Message>? question);

  ChatInputState result(CompletionResponseModel? result);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatInputState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatInputState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatInputState call({
    int? chatId,
    bool? finished,
    bool? inProgress,
    ChatInput? input,
    dynamic? json,
    List<Message>? question,
    CompletionResponseModel? result,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatInputState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatInputState.copyWith.fieldName(...)`
class _$ChatInputStateCWProxyImpl implements _$ChatInputStateCWProxy {
  final ChatInputState _value;

  const _$ChatInputStateCWProxyImpl(this._value);

  @override
  ChatInputState chatId(int? chatId) => this(chatId: chatId);

  @override
  ChatInputState finished(bool finished) => this(finished: finished);

  @override
  ChatInputState inProgress(bool inProgress) => this(inProgress: inProgress);

  @override
  ChatInputState input(ChatInput? input) => this(input: input);

  @override
  ChatInputState json(dynamic json) => this(json: json);

  @override
  ChatInputState question(List<Message>? question) => this(question: question);

  @override
  ChatInputState result(CompletionResponseModel? result) =>
      this(result: result);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatInputState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatInputState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatInputState call({
    Object? chatId = const $CopyWithPlaceholder(),
    Object? finished = const $CopyWithPlaceholder(),
    Object? inProgress = const $CopyWithPlaceholder(),
    Object? input = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
  }) {
    return ChatInputState(
      chatId: chatId == const $CopyWithPlaceholder()
          ? _value.chatId
          // ignore: cast_nullable_to_non_nullable
          : chatId as int?,
      finished: finished == const $CopyWithPlaceholder() || finished == null
          ? _value.finished
          // ignore: cast_nullable_to_non_nullable
          : finished as bool,
      inProgress:
          inProgress == const $CopyWithPlaceholder() || inProgress == null
              ? _value.inProgress
              // ignore: cast_nullable_to_non_nullable
              : inProgress as bool,
      input: input == const $CopyWithPlaceholder()
          ? _value.input
          // ignore: cast_nullable_to_non_nullable
          : input as ChatInput?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      question: question == const $CopyWithPlaceholder()
          ? _value.question
          // ignore: cast_nullable_to_non_nullable
          : question as List<Message>?,
      result: result == const $CopyWithPlaceholder()
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as CompletionResponseModel?,
    );
  }
}

extension $ChatInputStateCopyWith on ChatInputState {
  /// Returns a callable class that can be used as follows: `instanceOfChatInputState.copyWith(...)` or like so:`instanceOfChatInputState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatInputStateCWProxy get copyWith => _$ChatInputStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatInputState _$ChatInputStateFromJson(Map<String, dynamic> json) =>
    ChatInputState(
      chatId: json['chatId'] as int?,
      finished: json['finished'] as bool? ?? false,
      result: json['result'] == null
          ? null
          : CompletionResponseModel.fromJson(
              json['result'] as Map<String, dynamic>),
      input: json['input'] == null
          ? null
          : ChatInput.fromJson(json['input'] as Map<String, dynamic>),
      question: (json['question'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      inProgress: json['inProgress'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatInputStateToJson(ChatInputState instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'inProgress': instance.inProgress,
      'finished': instance.finished,
      'result': instance.result,
      'input': instance.input,
      'question': instance.question,
    };
