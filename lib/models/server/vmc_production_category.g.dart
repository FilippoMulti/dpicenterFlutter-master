// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_production_category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcProductionCategoryCWProxy {
  VmcProductionCategory color(String? color);

  VmcProductionCategory json(dynamic json);

  VmcProductionCategory name(String? name);

  VmcProductionCategory vmcProductionCategoryCode(
      String? vmcProductionCategoryCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcProductionCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcProductionCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcProductionCategory call({
    String? color,
    dynamic? json,
    String? name,
    String? vmcProductionCategoryCode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcProductionCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcProductionCategory.copyWith.fieldName(...)`
class _$VmcProductionCategoryCWProxyImpl
    implements _$VmcProductionCategoryCWProxy {
  final VmcProductionCategory _value;

  const _$VmcProductionCategoryCWProxyImpl(this._value);

  @override
  VmcProductionCategory color(String? color) => this(color: color);

  @override
  VmcProductionCategory json(dynamic json) => this(json: json);

  @override
  VmcProductionCategory name(String? name) => this(name: name);

  @override
  VmcProductionCategory vmcProductionCategoryCode(
          String? vmcProductionCategoryCode) =>
      this(vmcProductionCategoryCode: vmcProductionCategoryCode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcProductionCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcProductionCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcProductionCategory call({
    Object? color = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? vmcProductionCategoryCode = const $CopyWithPlaceholder(),
  }) {
    return VmcProductionCategory(
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
      vmcProductionCategoryCode:
          vmcProductionCategoryCode == const $CopyWithPlaceholder()
              ? _value.vmcProductionCategoryCode
              // ignore: cast_nullable_to_non_nullable
              : vmcProductionCategoryCode as String?,
    );
  }
}

extension $VmcProductionCategoryCopyWith on VmcProductionCategory {
  /// Returns a callable class that can be used as follows: `instanceOfVmcProductionCategory.copyWith(...)` or like so:`instanceOfVmcProductionCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcProductionCategoryCWProxy get copyWith =>
      _$VmcProductionCategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcProductionCategory _$VmcProductionCategoryFromJson(
        Map<String, dynamic> json) =>
    VmcProductionCategory(
      vmcProductionCategoryCode: json['vmcProductionCategoryCode'] as String?,
      name: json['name'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$VmcProductionCategoryToJson(
        VmcProductionCategory instance) =>
    <String, dynamic>{
      'vmcProductionCategoryCode': instance.vmcProductionCategoryCode,
      'name': instance.name,
      'color': instance.color,
    };
