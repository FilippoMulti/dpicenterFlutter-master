// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_configuration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcConfigurationCWProxy {
  VmcConfiguration description(String? description);

  VmcConfiguration json(dynamic json);

  VmcConfiguration vmcConfigurationId(int? vmcConfigurationId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcConfiguration call({
    String? description,
    dynamic? json,
    int? vmcConfigurationId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcConfiguration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcConfiguration.copyWith.fieldName(...)`
class _$VmcConfigurationCWProxyImpl implements _$VmcConfigurationCWProxy {
  final VmcConfiguration _value;

  const _$VmcConfigurationCWProxyImpl(this._value);

  @override
  VmcConfiguration description(String? description) =>
      this(description: description);

  @override
  VmcConfiguration json(dynamic json) => this(json: json);

  @override
  VmcConfiguration vmcConfigurationId(int? vmcConfigurationId) =>
      this(vmcConfigurationId: vmcConfigurationId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcConfiguration call({
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? vmcConfigurationId = const $CopyWithPlaceholder(),
  }) {
    return VmcConfiguration(
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      vmcConfigurationId: vmcConfigurationId == const $CopyWithPlaceholder()
          ? _value.vmcConfigurationId
          // ignore: cast_nullable_to_non_nullable
          : vmcConfigurationId as int?,
    );
  }
}

extension $VmcConfigurationCopyWith on VmcConfiguration {
  /// Returns a callable class that can be used as follows: `instanceOfVmcConfiguration.copyWith(...)` or like so:`instanceOfVmcConfiguration.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcConfigurationCWProxy get copyWith => _$VmcConfigurationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcConfiguration _$VmcConfigurationFromJson(Map<String, dynamic> json) =>
    VmcConfiguration(
      vmcConfigurationId: json['vmcConfigurationId'] as int?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$VmcConfigurationToJson(VmcConfiguration instance) =>
    <String, dynamic>{
      'vmcConfigurationId': instance.vmcConfigurationId,
      'description': instance.description,
    };
