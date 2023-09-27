// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_response_model_api.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationResponseModelApiCWProxy {
  ModerationResponseModelApi id(String id);

  ModerationResponseModelApi json(dynamic json);

  ModerationResponseModelApi model(String model);

  ModerationResponseModelApi results(List<ModerationResponseResultApi> results);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseModelApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseModelApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseModelApi call({
    String? id,
    dynamic? json,
    String? model,
    List<ModerationResponseResultApi>? results,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationResponseModelApi.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationResponseModelApi.copyWith.fieldName(...)`
class _$ModerationResponseModelApiCWProxyImpl
    implements _$ModerationResponseModelApiCWProxy {
  final ModerationResponseModelApi _value;

  const _$ModerationResponseModelApiCWProxyImpl(this._value);

  @override
  ModerationResponseModelApi id(String id) => this(id: id);

  @override
  ModerationResponseModelApi json(dynamic json) => this(json: json);

  @override
  ModerationResponseModelApi model(String model) => this(model: model);

  @override
  ModerationResponseModelApi results(
          List<ModerationResponseResultApi> results) =>
      this(results: results);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseModelApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseModelApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseModelApi call({
    Object? id = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? model = const $CopyWithPlaceholder(),
    Object? results = const $CopyWithPlaceholder(),
  }) {
    return ModerationResponseModelApi(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      model: model == const $CopyWithPlaceholder() || model == null
          ? _value.model
          // ignore: cast_nullable_to_non_nullable
          : model as String,
      results: results == const $CopyWithPlaceholder() || results == null
          ? _value.results
          // ignore: cast_nullable_to_non_nullable
          : results as List<ModerationResponseResultApi>,
    );
  }
}

extension $ModerationResponseModelApiCopyWith on ModerationResponseModelApi {
  /// Returns a callable class that can be used as follows: `instanceOfModerationResponseModelApi.copyWith(...)` or like so:`instanceOfModerationResponseModelApi.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationResponseModelApiCWProxy get copyWith =>
      _$ModerationResponseModelApiCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationResponseModelApi _$ModerationResponseModelApiFromJson(
        Map<String, dynamic> json) =>
    ModerationResponseModelApi(
      id: json['id'] as String? ?? '',
      model: json['model'] as String? ?? '',
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => ModerationResponseResultApi.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ModerationResponseModelApiToJson(
        ModerationResponseModelApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'model': instance.model,
      'results': instance.results,
    };
