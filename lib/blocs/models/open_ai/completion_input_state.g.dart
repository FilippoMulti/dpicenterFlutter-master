// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_input_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompletionInputStateCWProxy {
  CompletionInputState completionId(int? completionId);

  CompletionInputState finished(bool finished);

  CompletionInputState inProgress(bool inProgress);

  CompletionInputState input(CompletionInput? input);

  CompletionInputState json(dynamic json);

  CompletionInputState question(String? question);

  CompletionInputState result(CompletionResponseModel? result);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompletionInputState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompletionInputState(...).copyWith(id: 12, name: "My name")
  /// ````
  CompletionInputState call({
    int? completionId,
    bool? finished,
    bool? inProgress,
    CompletionInput? input,
    dynamic? json,
    String? question,
    CompletionResponseModel? result,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompletionInputState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompletionInputState.copyWith.fieldName(...)`
class _$CompletionInputStateCWProxyImpl
    implements _$CompletionInputStateCWProxy {
  final CompletionInputState _value;

  const _$CompletionInputStateCWProxyImpl(this._value);

  @override
  CompletionInputState completionId(int? completionId) =>
      this(completionId: completionId);

  @override
  CompletionInputState finished(bool finished) => this(finished: finished);

  @override
  CompletionInputState inProgress(bool inProgress) =>
      this(inProgress: inProgress);

  @override
  CompletionInputState input(CompletionInput? input) => this(input: input);

  @override
  CompletionInputState json(dynamic json) => this(json: json);

  @override
  CompletionInputState question(String? question) => this(question: question);

  @override
  CompletionInputState result(CompletionResponseModel? result) =>
      this(result: result);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompletionInputState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompletionInputState(...).copyWith(id: 12, name: "My name")
  /// ````
  CompletionInputState call({
    Object? completionId = const $CopyWithPlaceholder(),
    Object? finished = const $CopyWithPlaceholder(),
    Object? inProgress = const $CopyWithPlaceholder(),
    Object? input = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
  }) {
    return CompletionInputState(
      completionId: completionId == const $CopyWithPlaceholder()
          ? _value.completionId
          // ignore: cast_nullable_to_non_nullable
          : completionId as int?,
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
          : input as CompletionInput?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      question: question == const $CopyWithPlaceholder()
          ? _value.question
          // ignore: cast_nullable_to_non_nullable
          : question as String?,
      result: result == const $CopyWithPlaceholder()
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as CompletionResponseModel?,
    );
  }
}

extension $CompletionInputStateCopyWith on CompletionInputState {
  /// Returns a callable class that can be used as follows: `instanceOfCompletionInputState.copyWith(...)` or like so:`instanceOfCompletionInputState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompletionInputStateCWProxy get copyWith =>
      _$CompletionInputStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletionInputState _$CompletionInputStateFromJson(
        Map<String, dynamic> json) =>
    CompletionInputState(
      completionId: json['completionId'] as int?,
      finished: json['finished'] as bool? ?? false,
      result: json['result'] == null
          ? null
          : CompletionResponseModel.fromJson(
              json['result'] as Map<String, dynamic>),
      input: json['input'] == null
          ? null
          : CompletionInput.fromJson(json['input'] as Map<String, dynamic>),
      question: json['question'] as String?,
      inProgress: json['inProgress'] as bool? ?? false,
    );

Map<String, dynamic> _$CompletionInputStateToJson(
        CompletionInputState instance) =>
    <String, dynamic>{
      'completionId': instance.completionId,
      'inProgress': instance.inProgress,
      'finished': instance.finished,
      'result': instance.result,
      'input': instance.input,
      'question': instance.question,
    };
