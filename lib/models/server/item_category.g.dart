// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemCategoryCWProxy {
  ItemCategory code(String code);

  ItemCategory description(String description);

  ItemCategory itemCategoryId(int itemCategoryId);

  ItemCategory json(dynamic json);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemCategory call({
    String? code,
    String? description,
    int? itemCategoryId,
    dynamic? json,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItemCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItemCategory.copyWith.fieldName(...)`
class _$ItemCategoryCWProxyImpl implements _$ItemCategoryCWProxy {
  final ItemCategory _value;

  const _$ItemCategoryCWProxyImpl(this._value);

  @override
  ItemCategory code(String code) => this(code: code);

  @override
  ItemCategory description(String description) =>
      this(description: description);

  @override
  ItemCategory itemCategoryId(int itemCategoryId) =>
      this(itemCategoryId: itemCategoryId);

  @override
  ItemCategory json(dynamic json) => this(json: json);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemCategory call({
    Object? code = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? itemCategoryId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
  }) {
    return ItemCategory(
      code: code == const $CopyWithPlaceholder() || code == null
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      description:
          description == const $CopyWithPlaceholder() || description == null
              ? _value.description
              // ignore: cast_nullable_to_non_nullable
              : description as String,
      itemCategoryId: itemCategoryId == const $CopyWithPlaceholder() ||
              itemCategoryId == null
          ? _value.itemCategoryId
          // ignore: cast_nullable_to_non_nullable
          : itemCategoryId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
    );
  }
}

extension $ItemCategoryCopyWith on ItemCategory {
  /// Returns a callable class that can be used as follows: `instanceOfItemCategory.copyWith(...)` or like so:`instanceOfItemCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemCategoryCWProxy get copyWith => _$ItemCategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCategory _$ItemCategoryFromJson(Map<String, dynamic> json) => ItemCategory(
      itemCategoryId: json['itemCategoryId'] as int,
      code: json['code'] as String? ?? "",
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$ItemCategoryToJson(ItemCategory instance) =>
    <String, dynamic>{
      'itemCategoryId': instance.itemCategoryId,
      'code': instance.code,
      'description': instance.description,
    };
