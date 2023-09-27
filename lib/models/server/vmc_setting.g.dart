// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_setting.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcSettingCWProxy {
  VmcSetting json(dynamic json);

  VmcSetting settingField(VmcSettingField? settingField);

  VmcSetting vmc(Vmc? vmc);

  VmcSetting vmcId(int? vmcId);

  VmcSetting vmcSettingFieldId(int? vmcSettingFieldId);

  VmcSetting vmcSettingId(int? vmcSettingId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSetting(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSetting(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSetting call({
    dynamic? json,
    VmcSettingField? settingField,
    Vmc? vmc,
    int? vmcId,
    int? vmcSettingFieldId,
    int? vmcSettingId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcSetting.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcSetting.copyWith.fieldName(...)`
class _$VmcSettingCWProxyImpl implements _$VmcSettingCWProxy {
  final VmcSetting _value;

  const _$VmcSettingCWProxyImpl(this._value);

  @override
  VmcSetting json(dynamic json) => this(json: json);

  @override
  VmcSetting settingField(VmcSettingField? settingField) =>
      this(settingField: settingField);

  @override
  VmcSetting vmc(Vmc? vmc) => this(vmc: vmc);

  @override
  VmcSetting vmcId(int? vmcId) => this(vmcId: vmcId);

  @override
  VmcSetting vmcSettingFieldId(int? vmcSettingFieldId) =>
      this(vmcSettingFieldId: vmcSettingFieldId);

  @override
  VmcSetting vmcSettingId(int? vmcSettingId) =>
      this(vmcSettingId: vmcSettingId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSetting(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSetting(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSetting call({
    Object? json = const $CopyWithPlaceholder(),
    Object? settingField = const $CopyWithPlaceholder(),
    Object? vmc = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
    Object? vmcSettingFieldId = const $CopyWithPlaceholder(),
    Object? vmcSettingId = const $CopyWithPlaceholder(),
  }) {
    return VmcSetting(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      settingField: settingField == const $CopyWithPlaceholder()
          ? _value.settingField
          // ignore: cast_nullable_to_non_nullable
          : settingField as VmcSettingField?,
      vmc: vmc == const $CopyWithPlaceholder()
          ? _value.vmc
          // ignore: cast_nullable_to_non_nullable
          : vmc as Vmc?,
      vmcId: vmcId == const $CopyWithPlaceholder()
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int?,
      vmcSettingFieldId: vmcSettingFieldId == const $CopyWithPlaceholder()
          ? _value.vmcSettingFieldId
          // ignore: cast_nullable_to_non_nullable
          : vmcSettingFieldId as int?,
      vmcSettingId: vmcSettingId == const $CopyWithPlaceholder()
          ? _value.vmcSettingId
          // ignore: cast_nullable_to_non_nullable
          : vmcSettingId as int?,
    );
  }
}

extension $VmcSettingCopyWith on VmcSetting {
  /// Returns a callable class that can be used as follows: `instanceOfVmcSetting.copyWith(...)` or like so:`instanceOfVmcSetting.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcSettingCWProxy get copyWith => _$VmcSettingCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcSetting _$VmcSettingFromJson(Map<String, dynamic> json) => VmcSetting(
      vmcSettingId: json['vmcSettingId'] as int?,
      vmcSettingFieldId: json['vmcSettingFieldId'] as int?,
      vmcId: json['vmcId'] as int?,
      settingField: json['settingField'] == null
          ? null
          : VmcSettingField.fromJson(
              json['settingField'] as Map<String, dynamic>),
      vmc: json['vmc'] == null
          ? null
          : Vmc.fromJson(json['vmc'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VmcSettingToJson(VmcSetting instance) =>
    <String, dynamic>{
      'vmcSettingId': instance.vmcSettingId,
      'vmcSettingFieldId': instance.vmcSettingFieldId,
      'settingField': instance.settingField,
      'vmcId': instance.vmcId,
      'vmc': instance.vmc,
    };
