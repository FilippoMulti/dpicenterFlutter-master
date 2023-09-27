// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_response_category_scores_api.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationResponseCategoryScoresApiCWProxy {
  ModerationResponseCategoryScoresApi hate(double hate);

  ModerationResponseCategoryScoresApi hateThreatening(double hateThreatening);

  ModerationResponseCategoryScoresApi json(dynamic json);

  ModerationResponseCategoryScoresApi selfHarm(double selfHarm);

  ModerationResponseCategoryScoresApi sexual(double sexual);

  ModerationResponseCategoryScoresApi sexualMinors(double sexualMinors);

  ModerationResponseCategoryScoresApi violence(double violence);

  ModerationResponseCategoryScoresApi violenceGraphic(double violenceGraphic);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseCategoryScoresApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseCategoryScoresApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseCategoryScoresApi call({
    double? hate,
    double? hateThreatening,
    dynamic? json,
    double? selfHarm,
    double? sexual,
    double? sexualMinors,
    double? violence,
    double? violenceGraphic,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationResponseCategoryScoresApi.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationResponseCategoryScoresApi.copyWith.fieldName(...)`
class _$ModerationResponseCategoryScoresApiCWProxyImpl
    implements _$ModerationResponseCategoryScoresApiCWProxy {
  final ModerationResponseCategoryScoresApi _value;

  const _$ModerationResponseCategoryScoresApiCWProxyImpl(this._value);

  @override
  ModerationResponseCategoryScoresApi hate(double hate) => this(hate: hate);

  @override
  ModerationResponseCategoryScoresApi hateThreatening(double hateThreatening) =>
      this(hateThreatening: hateThreatening);

  @override
  ModerationResponseCategoryScoresApi json(dynamic json) => this(json: json);

  @override
  ModerationResponseCategoryScoresApi selfHarm(double selfHarm) =>
      this(selfHarm: selfHarm);

  @override
  ModerationResponseCategoryScoresApi sexual(double sexual) =>
      this(sexual: sexual);

  @override
  ModerationResponseCategoryScoresApi sexualMinors(double sexualMinors) =>
      this(sexualMinors: sexualMinors);

  @override
  ModerationResponseCategoryScoresApi violence(double violence) =>
      this(violence: violence);

  @override
  ModerationResponseCategoryScoresApi violenceGraphic(double violenceGraphic) =>
      this(violenceGraphic: violenceGraphic);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseCategoryScoresApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseCategoryScoresApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseCategoryScoresApi call({
    Object? hate = const $CopyWithPlaceholder(),
    Object? hateThreatening = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? selfHarm = const $CopyWithPlaceholder(),
    Object? sexual = const $CopyWithPlaceholder(),
    Object? sexualMinors = const $CopyWithPlaceholder(),
    Object? violence = const $CopyWithPlaceholder(),
    Object? violenceGraphic = const $CopyWithPlaceholder(),
  }) {
    return ModerationResponseCategoryScoresApi(
      hate: hate == const $CopyWithPlaceholder() || hate == null
          ? _value.hate
          // ignore: cast_nullable_to_non_nullable
          : hate as double,
      hateThreatening: hateThreatening == const $CopyWithPlaceholder() ||
              hateThreatening == null
          ? _value.hateThreatening
          // ignore: cast_nullable_to_non_nullable
          : hateThreatening as double,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      selfHarm: selfHarm == const $CopyWithPlaceholder() || selfHarm == null
          ? _value.selfHarm
          // ignore: cast_nullable_to_non_nullable
          : selfHarm as double,
      sexual: sexual == const $CopyWithPlaceholder() || sexual == null
          ? _value.sexual
          // ignore: cast_nullable_to_non_nullable
          : sexual as double,
      sexualMinors:
          sexualMinors == const $CopyWithPlaceholder() || sexualMinors == null
              ? _value.sexualMinors
              // ignore: cast_nullable_to_non_nullable
              : sexualMinors as double,
      violence: violence == const $CopyWithPlaceholder() || violence == null
          ? _value.violence
          // ignore: cast_nullable_to_non_nullable
          : violence as double,
      violenceGraphic: violenceGraphic == const $CopyWithPlaceholder() ||
              violenceGraphic == null
          ? _value.violenceGraphic
          // ignore: cast_nullable_to_non_nullable
          : violenceGraphic as double,
    );
  }
}

extension $ModerationResponseCategoryScoresApiCopyWith
    on ModerationResponseCategoryScoresApi {
  /// Returns a callable class that can be used as follows: `instanceOfModerationResponseCategoryScoresApi.copyWith(...)` or like so:`instanceOfModerationResponseCategoryScoresApi.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationResponseCategoryScoresApiCWProxy get copyWith =>
      _$ModerationResponseCategoryScoresApiCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationResponseCategoryScoresApi
    _$ModerationResponseCategoryScoresApiFromJson(Map<String, dynamic> json) =>
        ModerationResponseCategoryScoresApi(
          hate: (json['hate'] as num?)?.toDouble() ?? 0.0,
          hateThreatening: (json['hateThreatening'] as num?)?.toDouble() ?? 0.0,
          selfHarm: (json['selfHarm'] as num?)?.toDouble() ?? 0.0,
          sexual: (json['sexual'] as num?)?.toDouble() ?? 0.0,
          sexualMinors: (json['sexualMinors'] as num?)?.toDouble() ?? 0.0,
          violence: (json['violence'] as num?)?.toDouble() ?? 0.0,
          violenceGraphic: (json['violenceGraphic'] as num?)?.toDouble() ?? 0.0,
        );

Map<String, dynamic> _$ModerationResponseCategoryScoresApiToJson(
        ModerationResponseCategoryScoresApi instance) =>
    <String, dynamic>{
      'hate': instance.hate,
      'hateThreatening': instance.hateThreatening,
      'selfHarm': instance.selfHarm,
      'sexual': instance.sexual,
      'sexualMinors': instance.sexualMinors,
      'violence': instance.violence,
      'violenceGraphic': instance.violenceGraphic,
    };
