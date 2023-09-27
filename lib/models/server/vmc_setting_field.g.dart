// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_setting_field.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcSettingFieldCWProxy {
  VmcSettingField category(VmcSettingCategory? category);

  VmcSettingField description(String? description);

  VmcSettingField json(dynamic json);

  VmcSettingField name(String? name);

  VmcSettingField params(String? params);

  VmcSettingField type(int? type);

  VmcSettingField vmcSettingCategoryCode(String? vmcSettingCategoryCode);

  VmcSettingField vmcSettingFieldId(int? vmcSettingFieldId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSettingField(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSettingField(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSettingField call({
    VmcSettingCategory? category,
    String? description,
    dynamic? json,
    String? name,
    String? params,
    int? type,
    String? vmcSettingCategoryCode,
    int? vmcSettingFieldId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcSettingField.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcSettingField.copyWith.fieldName(...)`
class _$VmcSettingFieldCWProxyImpl implements _$VmcSettingFieldCWProxy {
  final VmcSettingField _value;

  const _$VmcSettingFieldCWProxyImpl(this._value);

  @override
  VmcSettingField category(VmcSettingCategory? category) =>
      this(category: category);

  @override
  VmcSettingField description(String? description) =>
      this(description: description);

  @override
  VmcSettingField json(dynamic json) => this(json: json);

  @override
  VmcSettingField name(String? name) => this(name: name);

  @override
  VmcSettingField params(String? params) => this(params: params);

  @override
  VmcSettingField type(int? type) => this(type: type);

  @override
  VmcSettingField vmcSettingCategoryCode(String? vmcSettingCategoryCode) =>
      this(vmcSettingCategoryCode: vmcSettingCategoryCode);

  @override
  VmcSettingField vmcSettingFieldId(int? vmcSettingFieldId) =>
      this(vmcSettingFieldId: vmcSettingFieldId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSettingField(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSettingField(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSettingField call({
    Object? category = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? params = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? vmcSettingCategoryCode = const $CopyWithPlaceholder(),
    Object? vmcSettingFieldId = const $CopyWithPlaceholder(),
  }) {
    return VmcSettingField(
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as VmcSettingCategory?,
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
      vmcSettingCategoryCode:
          vmcSettingCategoryCode == const $CopyWithPlaceholder()
              ? _value.vmcSettingCategoryCode
              // ignore: cast_nullable_to_non_nullable
              : vmcSettingCategoryCode as String?,
      vmcSettingFieldId: vmcSettingFieldId == const $CopyWithPlaceholder()
          ? _value.vmcSettingFieldId
          // ignore: cast_nullable_to_non_nullable
          : vmcSettingFieldId as int?,
    );
  }
}

extension $VmcSettingFieldCopyWith on VmcSettingField {
  /// Returns a callable class that can be used as follows: `instanceOfVmcSettingField.copyWith(...)` or like so:`instanceOfVmcSettingField.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcSettingFieldCWProxy get copyWith => _$VmcSettingFieldCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcSettingField _$VmcSettingFieldFromJson(Map<String, dynamic> json) =>
    VmcSettingField(
      vmcSettingFieldId: json['vmcSettingFieldId'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      vmcSettingCategoryCode: json['vmcSettingCategoryCode'] as String?,
      category: json['category'] == null
          ? null
          : VmcSettingCategory.fromJson(
              json['category'] as Map<String, dynamic>),
      type: json['type'] as int?,
      params: json['params'] as String?,
    );

Map<String, dynamic> _$VmcSettingFieldToJson(VmcSettingField instance) =>
    <String, dynamic>{
      'vmcSettingFieldId': instance.vmcSettingFieldId,
      'name': instance.name,
      'description': instance.description,
      'vmcSettingCategoryCode': instance.vmcSettingCategoryCode,
      'category': instance.category,
      'type': instance.type,
      'params': instance.params,
    };
