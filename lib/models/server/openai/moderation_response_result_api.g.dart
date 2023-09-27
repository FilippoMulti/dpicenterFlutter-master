// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_response_result_api.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationResponseResultApiCWProxy {
  ModerationResponseResultApi categories(
      ModerationResponseCategoriesApi? categories);

  ModerationResponseResultApi category_scores(
      ModerationResponseCategoryScoresApi? category_scores);

  ModerationResponseResultApi flagged(bool flagged);

  ModerationResponseResultApi json(dynamic json);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseResultApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseResultApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseResultApi call({
    ModerationResponseCategoriesApi? categories,
    ModerationResponseCategoryScoresApi? category_scores,
    bool? flagged,
    dynamic? json,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationResponseResultApi.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationResponseResultApi.copyWith.fieldName(...)`
class _$ModerationResponseResultApiCWProxyImpl
    implements _$ModerationResponseResultApiCWProxy {
  final ModerationResponseResultApi _value;

  const _$ModerationResponseResultApiCWProxyImpl(this._value);

  @override
  ModerationResponseResultApi categories(
          ModerationResponseCategoriesApi? categories) =>
      this(categories: categories);

  @override
  ModerationResponseResultApi category_scores(
          ModerationResponseCategoryScoresApi? category_scores) =>
      this(category_scores: category_scores);

  @override
  ModerationResponseResultApi flagged(bool flagged) => this(flagged: flagged);

  @override
  ModerationResponseResultApi json(dynamic json) => this(json: json);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationResponseResultApi(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationResponseResultApi(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationResponseResultApi call({
    Object? categories = const $CopyWithPlaceholder(),
    Object? category_scores = const $CopyWithPlaceholder(),
    Object? flagged = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
  }) {
    return ModerationResponseResultApi(
      categories: categories == const $CopyWithPlaceholder()
          ? _value.categories
          // ignore: cast_nullable_to_non_nullable
          : categories as ModerationResponseCategoriesApi?,
      category_scores: category_scores == const $CopyWithPlaceholder()
          ? _value.category_scores
          // ignore: cast_nullable_to_non_nullable
          : category_scores as ModerationResponseCategoryScoresApi?,
      flagged: flagged == const $CopyWithPlaceholder() || flagged == null
          ? _value.flagged
          // ignore: cast_nullable_to_non_nullable
          : flagged as bool,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
    );
  }
}

extension $ModerationResponseResultApiCopyWith on ModerationResponseResultApi {
  /// Returns a callable class that can be used as follows: `instanceOfModerationResponseResultApi.copyWith(...)` or like so:`instanceOfModerationResponseResultApi.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationResponseResultApiCWProxy get copyWith =>
      _$ModerationResponseResultApiCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationResponseResultApi _$ModerationResponseResultApiFromJson(
        Map<String, dynamic> json) =>
    ModerationResponseResultApi(
      flagged: json['flagged'] as bool? ?? false,
      categories: json['categories'] == null
          ? null
          : ModerationResponseCategoriesApi.fromJson(
              json['categories'] as Map<String, dynamic>),
      category_scores: json['category_scores'] == null
          ? null
          : ModerationResponseCategoryScoresApi.fromJson(
              json['category_scores'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModerationResponseResultApiToJson(
        ModerationResponseResultApi instance) =>
    <String, dynamic>{
      'flagged': instance.flagged,
      'categories': instance.categories,
      'category_scores': instance.category_scores,
    };
