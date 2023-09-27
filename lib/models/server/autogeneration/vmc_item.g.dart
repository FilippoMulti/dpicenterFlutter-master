// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcItemCWProxy {
  VmcItem color(int? color);

  VmcItem item(Item item);

  VmcItem itemConfiguration(SampleItemConfiguration? itemConfiguration);

  VmcItem itemId(int itemId);

  VmcItem json(dynamic json);

  VmcItem usageConfiguration(UsageConfiguration? usageConfiguration);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcItem(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcItem call({
    int? color,
    Item? item,
    SampleItemConfiguration? itemConfiguration,
    int? itemId,
    dynamic? json,
    UsageConfiguration? usageConfiguration,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcItem.copyWith.fieldName(...)`
class _$VmcItemCWProxyImpl implements _$VmcItemCWProxy {
  final VmcItem _value;

  const _$VmcItemCWProxyImpl(this._value);

  @override
  VmcItem color(int? color) => this(color: color);

  @override
  VmcItem item(Item item) => this(item: item);

  @override
  VmcItem itemConfiguration(SampleItemConfiguration? itemConfiguration) =>
      this(itemConfiguration: itemConfiguration);

  @override
  VmcItem itemId(int itemId) => this(itemId: itemId);

  @override
  VmcItem json(dynamic json) => this(json: json);

  @override
  VmcItem usageConfiguration(UsageConfiguration? usageConfiguration) =>
      this(usageConfiguration: usageConfiguration);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcItem(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcItem call({
    Object? color = const $CopyWithPlaceholder(),
    Object? item = const $CopyWithPlaceholder(),
    Object? itemConfiguration = const $CopyWithPlaceholder(),
    Object? itemId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? usageConfiguration = const $CopyWithPlaceholder(),
  }) {
    return VmcItem(
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as int?,
      item: item == const $CopyWithPlaceholder() || item == null
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as Item,
      itemConfiguration: itemConfiguration == const $CopyWithPlaceholder()
          ? _value.itemConfiguration
          // ignore: cast_nullable_to_non_nullable
          : itemConfiguration as SampleItemConfiguration?,
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      usageConfiguration: usageConfiguration == const $CopyWithPlaceholder()
          ? _value.usageConfiguration
          // ignore: cast_nullable_to_non_nullable
          : usageConfiguration as UsageConfiguration?,
    );
  }
}

extension $VmcItemCopyWith on VmcItem {
  /// Returns a callable class that can be used as follows: `instanceOfVmcItem.copyWith(...)` or like so:`instanceOfVmcItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcItemCWProxy get copyWith => _$VmcItemCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `VmcItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcItem(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  VmcItem copyWithNull({
    bool color = false,
    bool itemConfiguration = false,
    bool usageConfiguration = false,
  }) {
    return VmcItem(
      color: color == true ? null : this.color,
      item: item,
      itemConfiguration:
          itemConfiguration == true ? null : this.itemConfiguration,
      itemId: itemId,
      json: json,
      usageConfiguration:
          usageConfiguration == true ? null : this.usageConfiguration,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcItem _$VmcItemFromJson(Map<String, dynamic> json) => VmcItem(
      itemId: json['itemId'] as int,
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      itemConfiguration: json['itemConfiguration'] == null
          ? null
          : SampleItemConfiguration.fromJson(
              json['itemConfiguration'] as Map<String, dynamic>),
      usageConfiguration: json['usageConfiguration'] == null
          ? null
          : UsageConfiguration.fromJson(
              json['usageConfiguration'] as Map<String, dynamic>),
      color: json['color'] as int?,
    );

Map<String, dynamic> _$VmcItemToJson(VmcItem instance) => <String, dynamic>{
      'color': instance.color,
      'itemId': instance.itemId,
      'item': instance.item,
      'itemConfiguration': instance.itemConfiguration,
      'usageConfiguration': instance.usageConfiguration,
    };
