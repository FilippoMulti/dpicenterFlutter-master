// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_separator.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcSeparatorCWProxy {
  VmcSeparator itemId(int itemId);

  VmcSeparator json(dynamic json);

  VmcSeparator vmcId(int vmcId);

  VmcSeparator vmcSeparatorId(int vmcSeparatorId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSeparator(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSeparator(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSeparator call({
    int? itemId,
    dynamic? json,
    int? vmcId,
    int? vmcSeparatorId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcSeparator.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcSeparator.copyWith.fieldName(...)`
class _$VmcSeparatorCWProxyImpl implements _$VmcSeparatorCWProxy {
  final VmcSeparator _value;

  const _$VmcSeparatorCWProxyImpl(this._value);

  @override
  VmcSeparator itemId(int itemId) => this(itemId: itemId);

  @override
  VmcSeparator json(dynamic json) => this(json: json);

  @override
  VmcSeparator vmcId(int vmcId) => this(vmcId: vmcId);

  @override
  VmcSeparator vmcSeparatorId(int vmcSeparatorId) =>
      this(vmcSeparatorId: vmcSeparatorId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSeparator(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSeparator(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSeparator call({
    Object? itemId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
    Object? vmcSeparatorId = const $CopyWithPlaceholder(),
  }) {
    return VmcSeparator(
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      vmcId: vmcId == const $CopyWithPlaceholder() || vmcId == null
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int,
      vmcSeparatorId: vmcSeparatorId == const $CopyWithPlaceholder() ||
              vmcSeparatorId == null
          ? _value.vmcSeparatorId
          // ignore: cast_nullable_to_non_nullable
          : vmcSeparatorId as int,
    );
  }
}

extension $VmcSeparatorCopyWith on VmcSeparator {
  /// Returns a callable class that can be used as follows: `instanceOfVmcSeparator.copyWith(...)` or like so:`instanceOfVmcSeparator.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcSeparatorCWProxy get copyWith => _$VmcSeparatorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcSeparator _$VmcSeparatorFromJson(Map<String, dynamic> json) => VmcSeparator(
      vmcSeparatorId: json['vmcSeparatorId'] as int,
      vmcId: json['vmcId'] as int,
      itemId: json['itemId'] as int,
    );

Map<String, dynamic> _$VmcSeparatorToJson(VmcSeparator instance) =>
    <String, dynamic>{
      'vmcSeparatorId': instance.vmcSeparatorId,
      'vmcId': instance.vmcId,
      'itemId': instance.itemId,
    };
