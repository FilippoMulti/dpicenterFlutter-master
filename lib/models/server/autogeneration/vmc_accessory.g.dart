// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_accessory.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcAccessoryCWProxy {
  VmcAccessory itemId(int itemId);

  VmcAccessory json(dynamic json);

  VmcAccessory vmcAccessoryId(int vmcAccessoryId);

  VmcAccessory vmcId(int vmcId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcAccessory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcAccessory(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcAccessory call({
    int? itemId,
    dynamic? json,
    int? vmcAccessoryId,
    int? vmcId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcAccessory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcAccessory.copyWith.fieldName(...)`
class _$VmcAccessoryCWProxyImpl implements _$VmcAccessoryCWProxy {
  final VmcAccessory _value;

  const _$VmcAccessoryCWProxyImpl(this._value);

  @override
  VmcAccessory itemId(int itemId) => this(itemId: itemId);

  @override
  VmcAccessory json(dynamic json) => this(json: json);

  @override
  VmcAccessory vmcAccessoryId(int vmcAccessoryId) =>
      this(vmcAccessoryId: vmcAccessoryId);

  @override
  VmcAccessory vmcId(int vmcId) => this(vmcId: vmcId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcAccessory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcAccessory(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcAccessory call({
    Object? itemId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? vmcAccessoryId = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
  }) {
    return VmcAccessory(
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      vmcAccessoryId: vmcAccessoryId == const $CopyWithPlaceholder() ||
              vmcAccessoryId == null
          ? _value.vmcAccessoryId
          // ignore: cast_nullable_to_non_nullable
          : vmcAccessoryId as int,
      vmcId: vmcId == const $CopyWithPlaceholder() || vmcId == null
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int,
    );
  }
}

extension $VmcAccessoryCopyWith on VmcAccessory {
  /// Returns a callable class that can be used as follows: `instanceOfVmcAccessory.copyWith(...)` or like so:`instanceOfVmcAccessory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcAccessoryCWProxy get copyWith => _$VmcAccessoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcAccessory _$VmcAccessoryFromJson(Map<String, dynamic> json) => VmcAccessory(
      vmcAccessoryId: json['vmcAccessoryId'] as int,
      vmcId: json['vmcId'] as int,
      itemId: json['itemId'] as int,
    );

Map<String, dynamic> _$VmcAccessoryToJson(VmcAccessory instance) =>
    <String, dynamic>{
      'vmcAccessoryId': instance.vmcAccessoryId,
      'vmcId': instance.vmcId,
      'itemId': instance.itemId,
    };
