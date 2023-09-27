// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_frame_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataFrameResultCWProxy {
  DataFrameResult answer(String? answer);

  DataFrameResult attachments(String? attachments);

  DataFrameResult dataframeId(int? dataframeId);

  DataFrameResult json(dynamic json);

  DataFrameResult question(String? question);

  DataFrameResult result(String? result);

  DataFrameResult similarity(double similarity);

  DataFrameResult threshold(double threshold);

  DataFrameResult type(int type);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataFrameResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataFrameResult(...).copyWith(id: 12, name: "My name")
  /// ````
  DataFrameResult call({
    String? answer,
    String? attachments,
    int? dataframeId,
    dynamic? json,
    String? question,
    String? result,
    double? similarity,
    double? threshold,
    int? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDataFrameResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDataFrameResult.copyWith.fieldName(...)`
class _$DataFrameResultCWProxyImpl implements _$DataFrameResultCWProxy {
  final DataFrameResult _value;

  const _$DataFrameResultCWProxyImpl(this._value);

  @override
  DataFrameResult answer(String? answer) => this(answer: answer);

  @override
  DataFrameResult attachments(String? attachments) =>
      this(attachments: attachments);

  @override
  DataFrameResult dataframeId(int? dataframeId) =>
      this(dataframeId: dataframeId);

  @override
  DataFrameResult json(dynamic json) => this(json: json);

  @override
  DataFrameResult question(String? question) => this(question: question);

  @override
  DataFrameResult result(String? result) => this(result: result);

  @override
  DataFrameResult similarity(double similarity) => this(similarity: similarity);

  @override
  DataFrameResult threshold(double threshold) => this(threshold: threshold);

  @override
  DataFrameResult type(int type) => this(type: type);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataFrameResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataFrameResult(...).copyWith(id: 12, name: "My name")
  /// ````
  DataFrameResult call({
    Object? answer = const $CopyWithPlaceholder(),
    Object? attachments = const $CopyWithPlaceholder(),
    Object? dataframeId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
    Object? similarity = const $CopyWithPlaceholder(),
    Object? threshold = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return DataFrameResult(
      answer: answer == const $CopyWithPlaceholder()
          ? _value.answer
          // ignore: cast_nullable_to_non_nullable
          : answer as String?,
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as String?,
      dataframeId: dataframeId == const $CopyWithPlaceholder()
          ? _value.dataframeId
          // ignore: cast_nullable_to_non_nullable
          : dataframeId as int?,
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
          : result as String?,
      similarity:
          similarity == const $CopyWithPlaceholder() || similarity == null
              ? _value.similarity
              // ignore: cast_nullable_to_non_nullable
              : similarity as double,
      threshold: threshold == const $CopyWithPlaceholder() || threshold == null
          ? _value.threshold
          // ignore: cast_nullable_to_non_nullable
          : threshold as double,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as int,
    );
  }
}

extension $DataFrameResultCopyWith on DataFrameResult {
  /// Returns a callable class that can be used as follows: `instanceOfDataFrameResult.copyWith(...)` or like so:`instanceOfDataFrameResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DataFrameResultCWProxy get copyWith => _$DataFrameResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataFrameResult _$DataFrameResultFromJson(Map<String, dynamic> json) =>
    DataFrameResult(
      dataframeId: json['dataframeId'] as int?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0,
      result: json['result'] as String?,
      type: json['type'] as int? ?? 0,
      threshold: (json['threshold'] as num?)?.toDouble() ?? 0.0,
      attachments: json['attachments'] as String?,
    );

Map<String, dynamic> _$DataFrameResultToJson(DataFrameResult instance) =>
    <String, dynamic>{
      'dataframeId': instance.dataframeId,
      'question': instance.question,
      'answer': instance.answer,
      'similarity': instance.similarity,
      'result': instance.result,
      'type': instance.type,
      'threshold': instance.threshold,
      'attachments': instance.attachments,
    };
