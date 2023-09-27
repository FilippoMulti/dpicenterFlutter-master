// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_production_field.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcProductionFieldCWProxy {
  VmcProductionField category(VmcProductionCategory? category);

  VmcProductionField description(String? description);

  VmcProductionField json(dynamic json);

  VmcProductionField name(String? name);

  VmcProductionField params(String? params);

  VmcProductionField type(int? type);

  VmcProductionField vmcProductionCategoryCode(
      String? vmcProductionCategoryCode);

  VmcProductionField vmcProductionFieldId(int? vmcProductionFieldId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcProductionField(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcProductionField(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcProductionField call({
    VmcProductionCategory? category,
    String? description,
    dynamic? json,
    String? name,
    String? params,
    int? type,
    String? vmcProductionCategoryCode,
    int? vmcProductionFieldId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcProductionField.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcProductionField.copyWith.fieldName(...)`
class _$VmcProductionFieldCWProxyImpl implements _$VmcProductionFieldCWProxy {
  final VmcProductionField _value;

  const _$VmcProductionFieldCWProxyImpl(this._value);

  @override
  VmcProductionField category(VmcProductionCategory? category) =>
      this(category: category);

  @override
  VmcProductionField description(String? description) =>
      this(description: description);

  @override
  VmcProductionField json(dynamic json) => this(json: json);

  @override
  VmcProductionField name(String? name) => this(name: name);

  @override
  VmcProductionField params(String? params) => this(params: params);

  @override
  VmcProductionField type(int? type) => this(type: type);

  @override
  VmcProductionField vmcProductionCategoryCode(
          String? vmcProductionCategoryCode) =>
      this(vmcProductionCategoryCode: vmcProductionCategoryCode);

  @override
  VmcProductionField vmcProductionFieldId(int? vmcProductionFieldId) =>
      this(vmcProductionFieldId: vmcProductionFieldId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcProductionField(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcProductionField(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcProductionField call({
    Object? category = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? params = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? vmcProductionCategoryCode = const $CopyWithPlaceholder(),
    Object? vmcProductionFieldId = const $CopyWithPlaceholder(),
  }) {
    return VmcProductionField(
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as VmcProductionCategory?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      params: params == const $CopyWithPlaceholder()
          ? _value.params
          // ignore: cast_nullable_to_non_nullable
          : params as String?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as int?,
      vmcProductionCategoryCode:
          vmcProductionCategoryCode == const $CopyWithPlaceholder()
              ? _value.vmcProductionCategoryCode
              // ignore: cast_nullable_to_non_nullable
              : vmcProductionCategoryCode as String?,
      vmcProductionFieldId: vmcProductionFieldId == const $CopyWithPlaceholder()
          ? _value.vmcProductionFieldId
          // ignore: cast_nullable_to_non_nullable
          : vmcProductionFieldId as int?,
    );
  }
}

extension $VmcProductionFieldCopyWith on VmcProductionField {
  /// Returns a callable class that can be used as follows: `instanceOfVmcProductionField.copyWith(...)` or like so:`instanceOfVmcProductionField.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcProductionFieldCWProxy get copyWith =>
      _$VmcProductionFieldCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcProductionField _$VmcProductionFieldFromJson(Map<String, dynamic> json) =>
    VmcProductionField(
      vmcProductionFieldId: json['vmcProductionFieldId'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      vmcProductionCategoryCode: json['vmcProductionCategoryCode'] as String?,
      category: json['category'] == null
          ? null
          : VmcProductionCategory.fromJson(
              json['category'] as Map<String, dynamic>),
      type: json['type'] as int?,
      params: json['params'] as String?,
    );

Map<String, dynamic> _$VmcProductionFieldToJson(VmcProductionField instance) =>
    <String, dynamic>{
      'vmcProductionFieldId': instance.vmcProductionFieldId,
      'name': instance.name,
      'description': instance.description,
      'vmcProductionCategoryCode': instance.vmcProductionCategoryCode,
      'category': instance.category,
      'type': instance.type,
      'params': instance.params,
    };
