// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatInputCWProxy {
  ChatInput chatInputId(int chatInputId);

  ChatInput engine(String engine);

  ChatInput example(String? example);

  ChatInput exampleContext(String? exampleContext);

  ChatInput frequencyPenalty(double frequencyPenalty);

  ChatInput generateCompletion(bool generateCompletion);

  ChatInput generateSemanticResult(bool generateSemanticResult);

  ChatInput instruction(String? instruction);

  ChatInput json(dynamic json);

  ChatInput messages(List<Message>? messages);

  ChatInput presencePenalty(double presencePenalty);

  ChatInput searchType(int searchType);

  ChatInput temperature(double temperature);

  ChatInput thresholdModifier(double thresholdModifier);

  ChatInput tokens(int tokens);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatInput(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatInput call({
    int? chatInputId,
    String? engine,
    String? example,
    String? exampleContext,
    double? frequencyPenalty,
    bool? generateCompletion,
    bool? generateSemanticResult,
    String? instruction,
    dynamic? json,
    List<Message>? messages,
    double? presencePenalty,
    int? searchType,
    double? temperature,
    double? thresholdModifier,
    int? tokens,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatInput.copyWith.fieldName(...)`
class _$ChatInputCWProxyImpl implements _$ChatInputCWProxy {
  final ChatInput _value;

  const _$ChatInputCWProxyImpl(this._value);

  @override
  ChatInput chatInputId(int chatInputId) => this(chatInputId: chatInputId);

  @override
  ChatInput engine(String engine) => this(engine: engine);

  @override
  ChatInput example(String? example) => this(example: example);

  @override
  ChatInput exampleContext(String? exampleContext) =>
      this(exampleContext: exampleContext);

  @override
  ChatInput frequencyPenalty(double frequencyPenalty) =>
      this(frequencyPenalty: frequencyPenalty);

  @override
  ChatInput generateCompletion(bool generateCompletion) =>
      this(generateCompletion: generateCompletion);

  @override
  ChatInput generateSemanticResult(bool generateSemanticResult) =>
      this(generateSemanticResult: generateSemanticResult);

  @override
  ChatInput instruction(String? instruction) => this(instruction: instruction);

  @override
  ChatInput json(dynamic json) => this(json: json);

  @override
  ChatInput messages(List<Message>? messages) => this(messages: messages);

  @override
  ChatInput presencePenalty(double presencePenalty) =>
      this(presencePenalty: presencePenalty);

  @override
  ChatInput searchType(int searchType) => this(searchType: searchType);

  @override
  ChatInput temperature(double temperature) => this(temperature: temperature);

  @override
  ChatInput thresholdModifier(double thresholdModifier) =>
      this(thresholdModifier: thresholdModifier);

  @override
  ChatInput tokens(int tokens) => this(tokens: tokens);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatInput(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatInput call({
    Object? chatInputId = const $CopyWithPlaceholder(),
    Object? engine = const $CopyWithPlaceholder(),
    Object? example = const $CopyWithPlaceholder(),
    Object? exampleContext = const $CopyWithPlaceholder(),
    Object? frequencyPenalty = const $CopyWithPlaceholder(),
    Object? generateCompletion = const $CopyWithPlaceholder(),
    Object? generateSemanticResult = const $CopyWithPlaceholder(),
    Object? instruction = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? messages = const $CopyWithPlaceholder(),
    Object? presencePenalty = const $CopyWithPlaceholder(),
    Object? searchType = const $CopyWithPlaceholder(),
    Object? temperature = const $CopyWithPlaceholder(),
    Object? thresholdModifier = const $CopyWithPlaceholder(),
    Object? tokens = const $CopyWithPlaceholder(),
  }) {
    return ChatInput(
      chatInputId:
          chatInputId == const $CopyWithPlaceholder() || chatInputId == null
              ? _value.chatInputId
              // ignore: cast_nullable_to_non_nullable
              : chatInputId as int,
      engine: engine == const $CopyWithPlaceholder() || engine == null
          ? _value.engine
          // ignore: cast_nullable_to_non_nullable
          : engine as String,
      example: example == const $CopyWithPlaceholder()
          ? _value.example
          // ignore: cast_nullable_to_non_nullable
          : example as String?,
      exampleContext: exampleContext == const $CopyWithPlaceholder()
          ? _value.exampleContext
          // ignore: cast_nullable_to_non_nullable
          : exampleContext as String?,
      frequencyPenalty: frequencyPenalty == const $CopyWithPlaceholder() ||
              frequencyPenalty == null
          ? _value.frequencyPenalty
          // ignore: cast_nullable_to_non_nullable
          : frequencyPenalty as double,
      generateCompletion: generateCompletion == const $CopyWithPlaceholder() ||
              generateCompletion == null
          ? _value.generateCompletion
          // ignore: cast_nullable_to_non_nullable
          : generateCompletion as bool,
      generateSemanticResult:
          generateSemanticResult == const $CopyWithPlaceholder() ||
                  generateSemanticResult == null
              ? _value.generateSemanticResult
              // ignore: cast_nullable_to_non_nullable
              : generateSemanticResult as bool,
      instruction: instruction == const $CopyWithPlaceholder()
          ? _value.instruction
          // ignore: cast_nullable_to_non_nullable
          : instruction as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      messages: messages == const $CopyWithPlaceholder()
          ? _value.messages
          // ignore: cast_nullable_to_non_nullable
          : messages as List<Message>?,
      presencePenalty: presencePenalty == const $CopyWithPlaceholder() ||
              presencePenalty == null
          ? _value.presencePenalty
          // ignore: cast_nullable_to_non_nullable
          : presencePenalty as double,
      searchType:
          searchType == const $CopyWithPlaceholder() || searchType == null
              ? _value.searchType
              // ignore: cast_nullable_to_non_nullable
              : searchType as int,
      temperature:
          temperature == const $CopyWithPlaceholder() || temperature == null
              ? _value.temperature
              // ignore: cast_nullable_to_non_nullable
              : temperature as double,
      thresholdModifier: thresholdModifier == const $CopyWithPlaceholder() ||
              thresholdModifier == null
          ? _value.thresholdModifier
          // ignore: cast_nullable_to_non_nullable
          : thresholdModifier as double,
      tokens: tokens == const $CopyWithPlaceholder() || tokens == null
          ? _value.tokens
          // ignore: cast_nullable_to_non_nullable
          : tokens as int,
    );
  }
}

extension $ChatInputCopyWith on ChatInput {
  /// Returns a callable class that can be used as follows: `instanceOfChatInput.copyWith(...)` or like so:`instanceOfChatInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatInputCWProxy get copyWith => _$ChatInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatInput _$ChatInputFromJson(Map<String, dynamic> json) => ChatInput(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      tokens: json['tokens'] as int? ?? 2000,
      engine: json['engine'] as String? ?? "gpt-3.5-turbo",
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.01,
      presencePenalty: (json['presencePenalty'] as num?)?.toDouble() ?? 0.1,
      frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble() ?? 0.1,
      instruction: json['instruction'] as String?,
      exampleContext: json['exampleContext'] as String?,
      example: json['example'] as String?,
      generateCompletion: json['generateCompletion'] as bool? ?? true,
      generateSemanticResult: json['generateSemanticResult'] as bool? ?? true,
      thresholdModifier: (json['thresholdModifier'] as num?)?.toDouble() ?? 0,
      searchType: json['searchType'] as int? ?? 0,
      chatInputId: json['chatInputId'] as int,
    );

Map<String, dynamic> _$ChatInputToJson(ChatInput instance) => <String, dynamic>{
      'messages': instance.messages,
      'engine': instance.engine,
      'tokens': instance.tokens,
      'chatInputId': instance.chatInputId,
      'temperature': instance.temperature,
      'presencePenalty': instance.presencePenalty,
      'frequencyPenalty': instance.frequencyPenalty,
      'instruction': instance.instruction,
      'exampleContext': instance.exampleContext,
      'example': instance.example,
      'thresholdModifier': instance.thresholdModifier,
      'generateCompletion': instance.generateCompletion,
      'generateSemanticResult': instance.generateSemanticResult,
      'searchType': instance.searchType,
    };
