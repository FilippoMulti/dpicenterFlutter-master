// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PredictionInputCWProxy {
  PredictionInput json(dynamic json);

  PredictionInput prompt(String prompt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PredictionInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PredictionInput(...).copyWith(id: 12, name: "My name")
  /// ````
  PredictionInput call({
    dynamic? json,
    String? prompt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPredictionInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPredictionInput.copyWith.fieldName(...)`
class _$PredictionInputCWProxyImpl implements _$PredictionInputCWProxy {
  final PredictionInput _value;

  const _$PredictionInputCWProxyImpl(this._value);

  @override
  PredictionInput json(dynamic json) => this(json: json);

  @override
  PredictionInput prompt(String prompt) => this(prompt: prompt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PredictionInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PredictionInput(...).copyWith(id: 12, name: "My name")
  /// ````
  PredictionInput call({
    Object? json = const $CopyWithPlaceholder(),
    Object? prompt = const $CopyWithPlaceholder(),
  }) {
    return PredictionInput(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      prompt: prompt == const $CopyWithPlaceholder() || prompt == null
          ? _value.prompt
          // ignore: cast_nullable_to_non_nullable
          : prompt as String,
    );
  }
}

extension $PredictionInputCopyWith on PredictionInput {
  /// Returns a callable class that can be used as follows: `instanceOfPredictionInput.copyWith(...)` or like so:`instanceOfPredictionInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PredictionInputCWProxy get copyWith => _$PredictionInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictionInput _$PredictionInputFromJson(Map<String, dynamic> json) =>
    PredictionInput(
      prompt: json['prompt'] as String? ?? "",
    );

Map<String, dynamic> _$PredictionInputToJson(PredictionInput instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
    };
