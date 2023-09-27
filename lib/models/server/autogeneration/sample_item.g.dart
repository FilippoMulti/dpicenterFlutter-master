// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SampleItemCWProxy {
  SampleItem item(Item item);

  SampleItem itemConfiguration(SampleItemConfiguration? itemConfiguration);

  SampleItem itemConfigurationId(int? itemConfigurationId);

  SampleItem itemId(int itemId);

  SampleItem itemPictures(List<SampleItemPicture>? itemPictures);

  SampleItem json(dynamic json);

  SampleItem sampleItemCategory(SampleItemCategory? sampleItemCategory);

  SampleItem sampleItemCategoryId(int? sampleItemCategoryId);

  SampleItem sampleItemId(int sampleItemId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItem(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItem call({
    Item? item,
    SampleItemConfiguration? itemConfiguration,
    int? itemConfigurationId,
    int? itemId,
    List<SampleItemPicture>? itemPictures,
    dynamic? json,
    SampleItemCategory? sampleItemCategory,
    int? sampleItemCategoryId,
    int? sampleItemId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSampleItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSampleItem.copyWith.fieldName(...)`
class _$SampleItemCWProxyImpl implements _$SampleItemCWProxy {
  final SampleItem _value;

  const _$SampleItemCWProxyImpl(this._value);

  @override
  SampleItem item(Item item) => this(item: item);

  @override
  SampleItem itemConfiguration(SampleItemConfiguration? itemConfiguration) =>
      this(itemConfiguration: itemConfiguration);

  @override
  SampleItem itemConfigurationId(int? itemConfigurationId) =>
      this(itemConfigurationId: itemConfigurationId);

  @override
  SampleItem itemId(int itemId) => this(itemId: itemId);

  @override
  SampleItem itemPictures(List<SampleItemPicture>? itemPictures) =>
      this(itemPictures: itemPictures);

  @override
  SampleItem json(dynamic json) => this(json: json);

  @override
  SampleItem sampleItemCategory(SampleItemCategory? sampleItemCategory) =>
      this(sampleItemCategory: sampleItemCategory);

  @override
  SampleItem sampleItemCategoryId(int? sampleItemCategoryId) =>
      this(sampleItemCategoryId: sampleItemCategoryId);

  @override
  SampleItem sampleItemId(int sampleItemId) => this(sampleItemId: sampleItemId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItem(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItem call({
    Object? item = const $CopyWithPlaceholder(),
    Object? itemConfiguration = const $CopyWithPlaceholder(),
    Object? itemConfigurationId = const $CopyWithPlaceholder(),
    Object? itemId = const $CopyWithPlaceholder(),
    Object? itemPictures = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? sampleItemCategory = const $CopyWithPlaceholder(),
    Object? sampleItemCategoryId = const $CopyWithPlaceholder(),
    Object? sampleItemId = const $CopyWithPlaceholder(),
  }) {
    return SampleItem(
      item: item == const $CopyWithPlaceholder() || item == null
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as Item,
      itemConfiguration: itemConfiguration == const $CopyWithPlaceholder()
          ? _value.itemConfiguration
          // ignore: cast_nullable_to_non_nullable
          : itemConfiguration as SampleItemConfiguration?,
      itemConfigurationId: itemConfigurationId == const $CopyWithPlaceholder()
          ? _value.itemConfigurationId
          // ignore: cast_nullable_to_non_nullable
          : itemConfigurationId as int?,
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      itemPictures: itemPictures == const $CopyWithPlaceholder()
          ? _value.itemPictures
          // ignore: cast_nullable_to_non_nullable
          : itemPictures as List<SampleItemPicture>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      sampleItemCategory: sampleItemCategory == const $CopyWithPlaceholder()
          ? _value.sampleItemCategory
          // ignore: cast_nullable_to_non_nullable
          : sampleItemCategory as SampleItemCategory?,
      sampleItemCategoryId: sampleItemCategoryId == const $CopyWithPlaceholder()
          ? _value.sampleItemCategoryId
          // ignore: cast_nullable_to_non_nullable
          : sampleItemCategoryId as int?,
      sampleItemId:
          sampleItemId == const $CopyWithPlaceholder() || sampleItemId == null
              ? _value.sampleItemId
              // ignore: cast_nullable_to_non_nullable
              : sampleItemId as int,
    );
  }
}

extension $SampleItemCopyWith on SampleItem {
  /// Returns a callable class that can be used as follows: `instanceOfSampleItem.copyWith(...)` or like so:`instanceOfSampleItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SampleItemCWProxy get copyWith => _$SampleItemCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `SampleItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItem(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  SampleItem copyWithNull({
    bool itemConfiguration = false,
    bool itemConfigurationId = false,
    bool itemPictures = false,
    bool sampleItemCategory = false,
    bool sampleItemCategoryId = false,
  }) {
    return SampleItem(
      item: item,
      itemConfiguration:
          itemConfiguration == true ? null : this.itemConfiguration,
      itemConfigurationId:
          itemConfigurationId == true ? null : this.itemConfigurationId,
      itemId: itemId,
      itemPictures: itemPictures == true ? null : this.itemPictures,
      json: json,
      sampleItemCategory:
          sampleItemCategory == true ? null : this.sampleItemCategory,
      sampleItemCategoryId:
          sampleItemCategoryId == true ? null : this.sampleItemCategoryId,
      sampleItemId: sampleItemId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleItem _$SampleItemFromJson(Map<String, dynamic> json) => SampleItem(
      sampleItemId: json['sampleItemId'] as int,
      itemId: json['itemId'] as int,
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      itemConfigurationId: json['itemConfigurationId'] as int?,
      itemConfiguration: json['itemConfiguration'] == null
          ? null
          : SampleItemConfiguration.fromJson(
              json['itemConfiguration'] as Map<String, dynamic>),
      sampleItemCategoryId: json['sampleItemCategoryId'] as int?,
      sampleItemCategory: json['sampleItemCategory'] == null
          ? null
          : SampleItemCategory.fromJson(
              json['sampleItemCategory'] as Map<String, dynamic>),
      itemPictures: (json['itemPictures'] as List<dynamic>?)
          ?.map((e) => SampleItemPicture.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SampleItemToJson(SampleItem instance) =>
    <String, dynamic>{
      'sampleItemId': instance.sampleItemId,
      'itemId': instance.itemId,
      'item': instance.item,
      'itemConfigurationId': instance.itemConfigurationId,
      'itemConfiguration': instance.itemConfiguration,
      'sampleItemCategoryId': instance.sampleItemCategoryId,
      'sampleItemCategory': instance.sampleItemCategory,
      'itemPictures': instance.itemPictures,
    };
