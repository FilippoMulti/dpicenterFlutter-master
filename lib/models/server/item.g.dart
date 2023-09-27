// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemCWProxy {
  Item barcode(String? barcode);

  Item code(String? code);

  Item description(String? description);

  Item itemCategory(ItemCategory? itemCategory);

  Item itemCategoryId(int? itemCategoryId);

  Item itemId(int itemId);

  Item itemPhysicsId(int? itemPhysicsId);

  Item itemPictures(List<ItemPicture>? itemPictures);

  Item json(dynamic json);

  Item physicsConfiguration(ItemPhysicsConfiguration? physicsConfiguration);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Item(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Item(...).copyWith(id: 12, name: "My name")
  /// ````
  Item call({
    String? barcode,
    String? code,
    String? description,
    ItemCategory? itemCategory,
    int? itemCategoryId,
    int? itemId,
    int? itemPhysicsId,
    List<ItemPicture>? itemPictures,
    dynamic? json,
    ItemPhysicsConfiguration? physicsConfiguration,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItem.copyWith.fieldName(...)`
class _$ItemCWProxyImpl implements _$ItemCWProxy {
  final Item _value;

  const _$ItemCWProxyImpl(this._value);

  @override
  Item barcode(String? barcode) => this(barcode: barcode);

  @override
  Item code(String? code) => this(code: code);

  @override
  Item description(String? description) => this(description: description);

  @override
  Item itemCategory(ItemCategory? itemCategory) =>
      this(itemCategory: itemCategory);

  @override
  Item itemCategoryId(int? itemCategoryId) =>
      this(itemCategoryId: itemCategoryId);

  @override
  Item itemId(int itemId) => this(itemId: itemId);

  @override
  Item itemPhysicsId(int? itemPhysicsId) => this(itemPhysicsId: itemPhysicsId);

  @override
  Item itemPictures(List<ItemPicture>? itemPictures) =>
      this(itemPictures: itemPictures);

  @override
  Item json(dynamic json) => this(json: json);

  @override
  Item physicsConfiguration(ItemPhysicsConfiguration? physicsConfiguration) =>
      this(physicsConfiguration: physicsConfiguration);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Item(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Item(...).copyWith(id: 12, name: "My name")
  /// ````
  Item call({
    Object? barcode = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? itemCategory = const $CopyWithPlaceholder(),
    Object? itemCategoryId = const $CopyWithPlaceholder(),
    Object? itemId = const $CopyWithPlaceholder(),
    Object? itemPhysicsId = const $CopyWithPlaceholder(),
    Object? itemPictures = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? physicsConfiguration = const $CopyWithPlaceholder(),
  }) {
    return Item(
      barcode: barcode == const $CopyWithPlaceholder()
          ? _value.barcode
          // ignore: cast_nullable_to_non_nullable
          : barcode as String?,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      itemCategory: itemCategory == const $CopyWithPlaceholder()
          ? _value.itemCategory
          // ignore: cast_nullable_to_non_nullable
          : itemCategory as ItemCategory?,
      itemCategoryId: itemCategoryId == const $CopyWithPlaceholder()
          ? _value.itemCategoryId
          // ignore: cast_nullable_to_non_nullable
          : itemCategoryId as int?,
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      itemPhysicsId: itemPhysicsId == const $CopyWithPlaceholder()
          ? _value.itemPhysicsId
          // ignore: cast_nullable_to_non_nullable
          : itemPhysicsId as int?,
      itemPictures: itemPictures == const $CopyWithPlaceholder()
          ? _value.itemPictures
          // ignore: cast_nullable_to_non_nullable
          : itemPictures as List<ItemPicture>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      physicsConfiguration: physicsConfiguration == const $CopyWithPlaceholder()
          ? _value.physicsConfiguration
          // ignore: cast_nullable_to_non_nullable
          : physicsConfiguration as ItemPhysicsConfiguration?,
    );
  }
}

extension $ItemCopyWith on Item {
  /// Returns a callable class that can be used as follows: `instanceOfItem.copyWith(...)` or like so:`instanceOfItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemCWProxy get copyWith => _$ItemCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Item(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Item(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Item copyWithNull({
    bool barcode = false,
    bool code = false,
    bool description = false,
    bool itemCategory = false,
    bool itemCategoryId = false,
    bool itemPhysicsId = false,
    bool itemPictures = false,
    bool physicsConfiguration = false,
  }) {
    return Item(
      barcode: barcode == true ? null : this.barcode,
      code: code == true ? null : this.code,
      description: description == true ? null : this.description,
      itemCategory: itemCategory == true ? null : this.itemCategory,
      itemCategoryId: itemCategoryId == true ? null : this.itemCategoryId,
      itemId: itemId,
      itemPhysicsId: itemPhysicsId == true ? null : this.itemPhysicsId,
      itemPictures: itemPictures == true ? null : this.itemPictures,
      json: json,
      physicsConfiguration:
          physicsConfiguration == true ? null : this.physicsConfiguration,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      itemId: json['itemId'] as int,
      code: json['code'] as String?,
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      itemPictures: (json['itemPictures'] as List<dynamic>?)
          ?.map((e) => ItemPicture.fromJson(e as Map<String, dynamic>))
          .toList(),
      physicsConfiguration: json['physicsConfiguration'] == null
          ? null
          : ItemPhysicsConfiguration.fromJson(
              json['physicsConfiguration'] as Map<String, dynamic>),
      itemPhysicsId: json['itemPhysicsId'] as int?,
      itemCategory: json['itemCategory'] == null
          ? null
          : ItemCategory.fromJson(json['itemCategory'] as Map<String, dynamic>),
      itemCategoryId: json['itemCategoryId'] as int?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'code': instance.code,
      'description': instance.description,
      'barcode': instance.barcode,
      'itemPhysicsId': instance.itemPhysicsId,
      'physicsConfiguration': instance.physicsConfiguration,
      'itemPictures': instance.itemPictures,
      'itemCategoryId': instance.itemCategoryId,
      'itemCategory': instance.itemCategory,
    };
