// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_response_categories_api.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationResponseCategoriesApiCWProxy {
  ModerationResponseCategoriesApi hate(bool hate);

  ModerationResponseCategoriesApi hateThreatening(bool hateThreatening);

  ModerationResponseCategoriesApi json(dynamic json);

  ModerationResponseCategoriesApi selfHarm(bool selfHarm);

  ModerationResponseCategoriesApi sexual(bool sexual);

  ModerationResponseCategoriesApi sexualMinors(bool sexualMinors);

  ModerationResponseCategoriesApi violence(bool violence);

  ModerationResponseCategoriesApi violenceGraphic(bool violenceGraphic);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseCategoriesApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseCategoriesApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseCategoriesApi call({
    bool? hate,
    bool? hateThreatening,
    dynamic? json,
    bool? selfHarm,
    bool? sexual,
    bool? sexualMinors,
    bool? violence,
    bool? violenceGraphic,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationResponseCategoriesApi.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationResponseCategoriesApi.copyWith.fieldName(...)`
class _$ModerationResponseCategoriesApiCWProxyImpl
    implements _$ModerationResponseCategoriesApiCWProxy {
  final ModerationResponseCategoriesApi _value;

  const _$ModerationResponseCategoriesApiCWProxyImpl(this._value);

  @override
  ModerationResponseCategoriesApi hate(bool hate) => this(hate: hate);

  @override
  ModerationResponseCategoriesApi hateThreatening(bool hateThreatening) =>
      this(hateThreatening: hateThreatening);

  @override
  ModerationResponseCategoriesApi json(dynamic json) => this(json: json);

  @override
  ModerationResponseCategoriesApi selfHarm(bool selfHarm) =>
      this(selfHarm: selfHarm);

  @override
  ModerationResponseCategoriesApi sexual(bool sexual) => this(sexual: sexual);

  @override
  ModerationResponseCategoriesApi sexualMinors(bool sexualMinors) =>
      this(sexualMinors: sexualMinors);

  @override
  ModerationResponseCategoriesApi violence(bool violence) =>
      this(violence: violence);

  @override
  ModerationResponseCategoriesApi violenceGraphic(bool violenceGraphic) =>
      this(violenceGraphic: violenceGraphic);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseCategoriesApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseCategoriesApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseCategoriesApi call({
    Object? hate = const $CopyWithPlaceholder(),
    Object? hateThreatening = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? selfHarm = const $CopyWithPlaceholder(),
    Object? sexual = const $CopyWithPlaceholder(),
    Object? sexualMinors = const $CopyWithPlaceholder(),
    Object? violence = const $CopyWithPlaceholder(),
    Object? violenceGraphic = const $CopyWithPlaceholder(),
  }) {
    return ModerationResponseCategoriesApi(
      hate: hate == const $CopyWithPlaceholder() || hate == null
          ? _value.hate
          // ignore: cast_nullable_to_non_nullable
          : hate as bool,
      hateThreatening: hateThreatening == const $CopyWithPlaceholder() ||
              hateThreatening == null
          ? _value.hateThreatening
          // ignore: cast_nullable_to_non_nullable
          : hateThreatening as bool,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      selfHarm: selfHarm == const $CopyWithPlaceholder() || selfHarm == null
          ? _value.selfHarm
          // ignore: cast_nullable_to_non_nullable
          : selfHarm as bool,
      sexual: sexual == const $CopyWithPlaceholder() || sexual == null
          ? _value.sexual
          // ignore: cast_nullable_to_non_nullable
          : sexual as bool,
      sexualMinors:
          sexualMinors == const $CopyWithPlaceholder() || sexualMinors == null
              ? _value.sexualMinors
              // ignore: cast_nullable_to_non_nullable
              : sexualMinors as bool,
      violence: violence == const $CopyWithPlaceholder() || violence == null
          ? _value.violence
          // ignore: cast_nullable_to_non_nullable
          : violence as bool,
      violenceGraphic: violenceGraphic == const $CopyWithPlaceholder() ||
              violenceGraphic == null
          ? _value.violenceGraphic
          // ignore: cast_nullable_to_non_nullable
          : violenceGraphic as bool,
    );
  }
}

extension $ModerationResponseCategoriesApiCopyWith
    on ModerationResponseCategoriesApi {
  /// Returns a callable class that can be used as follows: `instanceOfModerationResponseCategoriesApi.copyWith(...)` or like so:`instanceOfModerationResponseCategoriesApi.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationResponseCategoriesApiCWProxy get copyWith =>
      _$ModerationResponseCategoriesApiCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationResponseCategoriesApi _$ModerationResponseCategoriesApiFromJson(
        Map<String, dynamic> json) =>
    ModerationResponseCategoriesApi(
      hate: json['hate'] as bool? ?? false,
      hateThreatening: json['hateThreatening'] as bool? ?? false,
      selfHarm: json['selfHarm'] as bool? ?? false,
      sexual: json['sexual'] as bool? ?? false,
      sexualMinors: json['sexualMinors'] as bool? ?? false,
      violence: json['violence'] as bool? ?? false,
      violenceGraphic: json['violenceGraphic'] as bool? ?? false,
    );

Map<String, dynamic> _$ModerationResponseCategoriesApiToJson(
        ModerationResponseCategoriesApi instance) =>
    <String, dynamic>{
      'hate': instance.hate,
      'hateThreatening': instance.hateThreatening,
      'selfHarm': instance.selfHarm,
      'sexual': instance.sexual,
      'sexualMinors': instance.sexualMinors,
      'violence': instance.violence,
      'violenceGraphic': instance.violenceGraphic,
    };
