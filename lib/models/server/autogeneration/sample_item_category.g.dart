// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_item_category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SampleItemCategoryCWProxy {
  SampleItemCategory code(String code);

  SampleItemCategory description(String description);

  SampleItemCategory json(dynamic json);

  SampleItemCategory sampleItemCategoryId(int sampleItemCategoryId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItemCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItemCategory call({
    String? code,
    String? description,
    dynamic? json,
    int? sampleItemCategoryId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSampleItemCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSampleItemCategory.copyWith.fieldName(...)`
class _$SampleItemCategoryCWProxyImpl implements _$SampleItemCategoryCWProxy {
  final SampleItemCategory _value;

  const _$SampleItemCategoryCWProxyImpl(this._value);

  @override
  SampleItemCategory code(String code) => this(code: code);

  @override
  SampleItemCategory description(String description) =>
      this(description: description);

  @override
  SampleItemCategory json(dynamic json) => this(json: json);

  @override
  SampleItemCategory sampleItemCategoryId(int sampleItemCategoryId) =>
      this(sampleItemCategoryId: sampleItemCategoryId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItemCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItemCategory call({
    Object? code = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? sampleItemCategoryId = const $CopyWithPlaceholder(),
  }) {
    return SampleItemCategory(
      code: code == const $CopyWithPlaceholder() || code == null
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      description:
          description == const $CopyWithPlaceholder() || description == null
              ? _value.description
              // ignore: cast_nullable_to_non_nullable
              : description as String,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      sampleItemCategoryId:
          sampleItemCategoryId == const $CopyWithPlaceholder() ||
                  sampleItemCategoryId == null
              ? _value.sampleItemCategoryId
              // ignore: cast_nullable_to_non_nullable
              : sampleItemCategoryId as int,
    );
  }
}

extension $SampleItemCategoryCopyWith on SampleItemCategory {
  /// Returns a callable class that can be used as follows: `instanceOfSampleItemCategory.copyWith(...)` or like so:`instanceOfSampleItemCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SampleItemCategoryCWProxy get copyWith =>
      _$SampleItemCategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleItemCategory _$SampleItemCategoryFromJson(Map<String, dynamic> json) =>
    SampleItemCategory(
      sampleItemCategoryId: json['sampleItemCategoryId'] as int,
      code: json['code'] as String? ?? "",
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$SampleItemCategoryToJson(SampleItemCategory instance) =>
    <String, dynamic>{
      'sampleItemCategoryId': instance.sampleItemCategoryId,
      'code': instance.code,
      'description': instance.description,
    };
