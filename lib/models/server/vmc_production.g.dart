// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_production.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcProductionCWProxy {
  VmcProduction json(dynamic json);

  VmcProduction productionField(VmcProductionField? productionField);

  VmcProduction vmc(Vmc? vmc);

  VmcProduction vmcId(int? vmcId);

  VmcProduction vmcProductionFieldId(int? vmcProductionFieldId);

  VmcProduction vmcProductionId(int? vmcProductionId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcProduction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcProduction(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcProduction call({
    dynamic? json,
    VmcProductionField? productionField,
    Vmc? vmc,
    int? vmcId,
    int? vmcProductionFieldId,
    int? vmcProductionId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcProduction.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcProduction.copyWith.fieldName(...)`
class _$VmcProductionCWProxyImpl implements _$VmcProductionCWProxy {
  final VmcProduction _value;

  const _$VmcProductionCWProxyImpl(this._value);

  @override
  VmcProduction json(dynamic json) => this(json: json);

  @override
  VmcProduction productionField(VmcProductionField? productionField) =>
      this(productionField: productionField);

  @override
  VmcProduction vmc(Vmc? vmc) => this(vmc: vmc);

  @override
  VmcProduction vmcId(int? vmcId) => this(vmcId: vmcId);

  @override
  VmcProduction vmcProductionFieldId(int? vmcProductionFieldId) =>
      this(vmcProductionFieldId: vmcProductionFieldId);

  @override
  VmcProduction vmcProductionId(int? vmcProductionId) =>
      this(vmcProductionId: vmcProductionId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcProduction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcProduction(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcProduction call({
    Object? json = const $CopyWithPlaceholder(),
    Object? productionField = const $CopyWithPlaceholder(),
    Object? vmc = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
    Object? vmcProductionFieldId = const $CopyWithPlaceholder(),
    Object? vmcProductionId = const $CopyWithPlaceholder(),
  }) {
    return VmcProduction(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      productionField: productionField == const $CopyWithPlaceholder()
          ? _value.productionField
          // ignore: cast_nullable_to_non_nullable
          : productionField as VmcProductionField?,
      vmc: vmc == const $CopyWithPlaceholder()
          ? _value.vmc
          // ignore: cast_nullable_to_non_nullable
          : vmc as Vmc?,
      vmcId: vmcId == const $CopyWithPlaceholder()
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int?,
      vmcProductionFieldId: vmcProductionFieldId == const $CopyWithPlaceholder()
          ? _value.vmcProductionFieldId
          // ignore: cast_nullable_to_non_nullable
          : vmcProductionFieldId as int?,
      vmcProductionId: vmcProductionId == const $CopyWithPlaceholder()
          ? _value.vmcProductionId
          // ignore: cast_nullable_to_non_nullable
          : vmcProductionId as int?,
    );
  }
}

extension $VmcProductionCopyWith on VmcProduction {
  /// Returns a callable class that can be used as follows: `instanceOfVmcProduction.copyWith(...)` or like so:`instanceOfVmcProduction.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcProductionCWProxy get copyWith => _$VmcProductionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcProduction _$VmcProductionFromJson(Map<String, dynamic> json) =>
    VmcProduction(
      vmcProductionId: json['vmcProductionId'] as int?,
      vmcProductionFieldId: json['vmcProductionFieldId'] as int?,
      vmcId: json['vmcId'] as int?,
      productionField: json['productionField'] == null
          ? null
          : VmcProductionField.fromJson(
              json['productionField'] as Map<String, dynamic>),
      vmc: json['vmc'] == null
          ? null
          : Vmc.fromJson(json['vmc'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VmcProductionToJson(VmcProduction instance) =>
    <String, dynamic>{
      'vmcProductionId': instance.vmcProductionId,
      'vmcProductionFieldId': instance.vmcProductionFieldId,
      'productionField': instance.productionField,
      'vmcId': instance.vmcId,
      'vmc': instance.vmc,
    };
