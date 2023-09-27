// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_frame.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataFrameCWProxy {
  DataFrame answer(String? answer);

  DataFrame attachments(String? attachments);

  DataFrame generate(bool generate);

  DataFrame id(int? id);

  DataFrame json(dynamic json);

  DataFrame question(String? question);

  DataFrame type(int type);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataFrame(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataFrame(...).copyWith(id: 12, name: "My name")
  /// ````
  DataFrame call({
    String? answer,
    String? attachments,
    bool? generate,
    int? id,
    dynamic? json,
    String? question,
    int? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDataFrame.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDataFrame.copyWith.fieldName(...)`
class _$DataFrameCWProxyImpl implements _$DataFrameCWProxy {
  final DataFrame _value;

  const _$DataFrameCWProxyImpl(this._value);

  @override
  DataFrame answer(String? answer) => this(answer: answer);

  @override
  DataFrame attachments(String? attachments) => this(attachments: attachments);

  @override
  DataFrame generate(bool generate) => this(generate: generate);

  @override
  DataFrame id(int? id) => this(id: id);

  @override
  DataFrame json(dynamic json) => this(json: json);

  @override
  DataFrame question(String? question) => this(question: question);

  @override
  DataFrame type(int type) => this(type: type);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataFrame(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataFrame(...).copyWith(id: 12, name: "My name")
  /// ````
  DataFrame call({
    Object? answer = const $CopyWithPlaceholder(),
    Object? attachments = const $CopyWithPlaceholder(),
    Object? generate = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return DataFrame(
      answer: answer == const $CopyWithPlaceholder()
          ? _value.answer
          // ignore: cast_nullable_to_non_nullable
          : answer as String?,
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as String?,
      generate: generate == const $CopyWithPlaceholder() || generate == null
          ? _value.generate
          // ignore: cast_nullable_to_non_nullable
          : generate as bool,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      question: question == const $CopyWithPlaceholder()
          ? _value.question
          // ignore: cast_nullable_to_non_nullable
          : question as String?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as int,
    );
  }
}

extension $DataFrameCopyWith on DataFrame {
  /// Returns a callable class that can be used as follows: `instanceOfDataFrame.copyWith(...)` or like so:`instanceOfDataFrame.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DataFrameCWProxy get copyWith => _$DataFrameCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataFrame _$DataFrameFromJson(Map<String, dynamic> json) => DataFrame(
      id: json['id'] as int?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      generate: json['generate'] as bool? ?? true,
      type: json['type'] as int? ?? 0,
      attachments: json['attachments'] as String?,
    );

Map<String, dynamic> _$DataFrameToJson(DataFrame instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'generate': instance.generate,
      'type': instance.type,
      'attachments': instance.attachments,
    };
