// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_setting_category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcSettingCategoryCWProxy {
  VmcSettingCategory color(String? color);

  VmcSettingCategory json(dynamic json);

  VmcSettingCategory name(String? name);

  VmcSettingCategory vmcSettingCategoryCode(String? vmcSettingCategoryCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSettingCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSettingCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSettingCategory call({
    String? color,
    dynamic? json,
    String? name,
    String? vmcSettingCategoryCode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcSettingCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcSettingCategory.copyWith.fieldName(...)`
class _$VmcSettingCategoryCWProxyImpl implements _$VmcSettingCategoryCWProxy {
  final VmcSettingCategory _value;

  const _$VmcSettingCategoryCWProxyImpl(this._value);

  @override
  VmcSettingCategory color(String? color) => this(color: color);

  @override
  VmcSettingCategory json(dynamic json) => this(json: json);

  @override
  VmcSettingCategory name(String? name) => this(name: name);

  @override
  VmcSettingCategory vmcSettingCategoryCode(String? vmcSettingCategoryCode) =>
      this(vmcSettingCategoryCode: vmcSettingCategoryCode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSettingCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSettingCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSettingCategory call({
    Object? color = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? vmcSettingCategoryCode = const $CopyWithPlaceholder(),
  }) {
    return VmcSettingCategory(
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      vmcSettingCategoryCode:
          vmcSettingCategoryCode == const $CopyWithPlaceholder()
              ? _value.vmcSettingCategoryCode
              // ignore: cast_nullable_to_non_nullable
              : vmcSettingCategoryCode as String?,
    );
  }
}

extension $VmcSettingCategoryCopyWith on VmcSettingCategory {
  /// Returns a callable class that can be used as follows: `instanceOfVmcSettingCategory.copyWith(...)` or like so:`instanceOfVmcSettingCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcSettingCategoryCWProxy get copyWith =>
      _$VmcSettingCategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcSettingCategory _$VmcSettingCategoryFromJson(Map<String, dynamic> json) =>
    VmcSettingCategory(
      vmcSettingCategoryCode: json['vmcSettingCategoryCode'] as String?,
      name: json['name'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$VmcSettingCategoryToJson(VmcSettingCategory instance) =>
    <String, dynamic>{
      'vmcSettingCategoryCode': instance.vmcSettingCategoryCode,
      'name': instance.name,
      'color': instance.color,
    };
