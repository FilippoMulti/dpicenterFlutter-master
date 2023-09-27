// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_response_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompletionResponseModelCWProxy {
  CompletionResponseModel completionInputId(int completionInputId);

  CompletionResponseModel data(String data);

  CompletionResponseModel inputModerationResult(
      ModerationResponseModelApi inputModerationResult);

  CompletionResponseModel json(dynamic json);

  CompletionResponseModel outputModerationResult(
      ModerationResponseModelApi outputModerationResult);

  CompletionResponseModel semanticSearchResult(
      List<DataFrameResult>? semanticSearchResult);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompletionResponseModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompletionResponseModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CompletionResponseModel call({
    int? completionInputId,
    String? data,
    ModerationResponseModelApi? inputModerationResult,
    dynamic? json,
    ModerationResponseModelApi? outputModerationResult,
    List<DataFrameResult>? semanticSearchResult,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompletionResponseModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompletionResponseModel.copyWith.fieldName(...)`
class _$CompletionResponseModelCWProxyImpl
    implements _$CompletionResponseModelCWProxy {
  final CompletionResponseModel _value;

  const _$CompletionResponseModelCWProxyImpl(this._value);

  @override
  CompletionResponseModel completionInputId(int completionInputId) =>
      this(completionInputId: completionInputId);

  @override
  CompletionResponseModel data(String data) => this(data: data);

  @override
  CompletionResponseModel inputModerationResult(
          ModerationResponseModelApi inputModerationResult) =>
      this(inputModerationResult: inputModerationResult);

  @override
  CompletionResponseModel json(dynamic json) => this(json: json);

  @override
  CompletionResponseModel outputModerationResult(
          ModerationResponseModelApi outputModerationResult) =>
      this(outputModerationResult: outputModerationResult);

  @override
  CompletionResponseModel semanticSearchResult(
          List<DataFrameResult>? semanticSearchResult) =>
      this(semanticSearchResult: semanticSearchResult);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompletionResponseModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompletionResponseModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CompletionResponseModel call({
    Object? completionInputId = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? inputModerationResult = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? outputModerationResult = const $CopyWithPlaceholder(),
    Object? semanticSearchResult = const $CopyWithPlaceholder(),
  }) {
    return CompletionResponseModel(
      completionInputId: completionInputId == const $CopyWithPlaceholder() ||
              completionInputId == null
          ? _value.completionInputId
          // ignore: cast_nullable_to_non_nullable
          : completionInputId as int,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as String,
      inputModerationResult:
          inputModerationResult == const $CopyWithPlaceholder() ||
                  inputModerationResult == null
              ? _value.inputModerationResult
              // ignore: cast_nullable_to_non_nullable
              : inputModerationResult as ModerationResponseModelApi,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      outputModerationResult:
          outputModerationResult == const $CopyWithPlaceholder() ||
                  outputModerationResult == null
              ? _value.outputModerationResult
              // ignore: cast_nullable_to_non_nullable
              : outputModerationResult as ModerationResponseModelApi,
      semanticSearchResult: semanticSearchResult == const $CopyWithPlaceholder()
          ? _value.semanticSearchResult
          // ignore: cast_nullable_to_non_nullable
          : semanticSearchResult as List<DataFrameResult>?,
    );
  }
}

extension $CompletionResponseModelCopyWith on CompletionResponseModel {
  /// Returns a callable class that can be used as follows: `instanceOfCompletionResponseModel.copyWith(...)` or like so:`instanceOfCompletionResponseModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompletionResponseModelCWProxy get copyWith =>
      _$CompletionResponseModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletionResponseModel _$CompletionResponseModelFromJson(
        Map<String, dynamic> json) =>
    CompletionResponseModel(
      completionInputId: json['completionInputId'] as int? ?? 0,
      data: json['data'] as String? ?? '',
      inputModerationResult: json['inputModerationResult'] == null
          ? const ModerationResponseModelApi()
          : ModerationResponseModelApi.fromJson(
              json['inputModerationResult'] as Map<String, dynamic>),
      outputModerationResult: json['outputModerationResult'] == null
          ? const ModerationResponseModelApi()
          : ModerationResponseModelApi.fromJson(
              json['outputModerationResult'] as Map<String, dynamic>),
      semanticSearchResult: (json['semanticSearchResult'] as List<dynamic>?)
          ?.map((e) => DataFrameResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompletionResponseModelToJson(
        CompletionResponseModel instance) =>
    <String, dynamic>{
      'completionInputId': instance.completionInputId,
      'data': instance.data,
      'inputModerationResult': instance.inputModerationResult,
      'outputModerationResult': instance.outputModerationResult,
      'semanticSearchResult': instance.semanticSearchResult,
    };
