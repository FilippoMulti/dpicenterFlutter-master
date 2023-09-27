// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_physics_configuration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcPhysicsConfigurationCWProxy {
  VmcPhysicsConfiguration contentHeight(double contentHeight);

  VmcPhysicsConfiguration contentWidth(double contentWidth);

  VmcPhysicsConfiguration drawerHeight(double drawerHeight);

  VmcPhysicsConfiguration json(dynamic json);

  VmcPhysicsConfiguration vmcDepthMm(double vmcDepthMm);

  VmcPhysicsConfiguration vmcHeightMm(double vmcHeightMm);

  VmcPhysicsConfiguration vmcPhysicsConfigurationId(
      int vmcPhysicsConfigurationId);

  VmcPhysicsConfiguration vmcWidthMm(double vmcWidthMm);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcPhysicsConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcPhysicsConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcPhysicsConfiguration call({
    double? contentHeight,
    double? contentWidth,
    double? drawerHeight,
    dynamic? json,
    double? vmcDepthMm,
    double? vmcHeightMm,
    int? vmcPhysicsConfigurationId,
    double? vmcWidthMm,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcPhysicsConfiguration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcPhysicsConfiguration.copyWith.fieldName(...)`
class _$VmcPhysicsConfigurationCWProxyImpl
    implements _$VmcPhysicsConfigurationCWProxy {
  final VmcPhysicsConfiguration _value;

  const _$VmcPhysicsConfigurationCWProxyImpl(this._value);

  @override
  VmcPhysicsConfiguration contentHeight(double contentHeight) =>
      this(contentHeight: contentHeight);

  @override
  VmcPhysicsConfiguration contentWidth(double contentWidth) =>
      this(contentWidth: contentWidth);

  @override
  VmcPhysicsConfiguration drawerHeight(double drawerHeight) =>
      this(drawerHeight: drawerHeight);

  @override
  VmcPhysicsConfiguration json(dynamic json) => this(json: json);

  @override
  VmcPhysicsConfiguration vmcDepthMm(double vmcDepthMm) =>
      this(vmcDepthMm: vmcDepthMm);

  @override
  VmcPhysicsConfiguration vmcHeightMm(double vmcHeightMm) =>
      this(vmcHeightMm: vmcHeightMm);

  @override
  VmcPhysicsConfiguration vmcPhysicsConfigurationId(
          int vmcPhysicsConfigurationId) =>
      this(vmcPhysicsConfigurationId: vmcPhysicsConfigurationId);

  @override
  VmcPhysicsConfiguration vmcWidthMm(double vmcWidthMm) =>
      this(vmcWidthMm: vmcWidthMm);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcPhysicsConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcPhysicsConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcPhysicsConfiguration call({
    Object? contentHeight = const $CopyWithPlaceholder(),
    Object? contentWidth = const $CopyWithPlaceholder(),
    Object? drawerHeight = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? vmcDepthMm = const $CopyWithPlaceholder(),
    Object? vmcHeightMm = const $CopyWithPlaceholder(),
    Object? vmcPhysicsConfigurationId = const $CopyWithPlaceholder(),
    Object? vmcWidthMm = const $CopyWithPlaceholder(),
  }) {
    return VmcPhysicsConfiguration(
      contentHeight:
          contentHeight == const $CopyWithPlaceholder() || contentHeight == null
              ? _value.contentHeight
              // ignore: cast_nullable_to_non_nullable
              : contentHeight as double,
      contentWidth:
          contentWidth == const $CopyWithPlaceholder() || contentWidth == null
              ? _value.contentWidth
              // ignore: cast_nullable_to_non_nullable
              : contentWidth as double,
      drawerHeight:
          drawerHeight == const $CopyWithPlaceholder() || drawerHeight == null
              ? _value.drawerHeight
              // ignore: cast_nullable_to_non_nullable
              : drawerHeight as double,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      vmcDepthMm:
          vmcDepthMm == const $CopyWithPlaceholder() || vmcDepthMm == null
              ? _value.vmcDepthMm
              // ignore: cast_nullable_to_non_nullable
              : vmcDepthMm as double,
      vmcHeightMm:
          vmcHeightMm == const $CopyWithPlaceholder() || vmcHeightMm == null
              ? _value.vmcHeightMm
              // ignore: cast_nullable_to_non_nullable
              : vmcHeightMm as double,
      vmcPhysicsConfigurationId:
          vmcPhysicsConfigurationId == const $CopyWithPlaceholder() ||
                  vmcPhysicsConfigurationId == null
              ? _value.vmcPhysicsConfigurationId
              // ignore: cast_nullable_to_non_nullable
              : vmcPhysicsConfigurationId as int,
      vmcWidthMm:
          vmcWidthMm == const $CopyWithPlaceholder() || vmcWidthMm == null
              ? _value.vmcWidthMm
              // ignore: cast_nullable_to_non_nullable
              : vmcWidthMm as double,
    );
  }
}

extension $VmcPhysicsConfigurationCopyWith on VmcPhysicsConfiguration {
  /// Returns a callable class that can be used as follows: `instanceOfVmcPhysicsConfiguration.copyWith(...)` or like so:`instanceOfVmcPhysicsConfiguration.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcPhysicsConfigurationCWProxy get copyWith =>
      _$VmcPhysicsConfigurationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcPhysicsConfiguration _$VmcPhysicsConfigurationFromJson(
        Map<String, dynamic> json) =>
    VmcPhysicsConfiguration(
      vmcPhysicsConfigurationId: json['vmcPhysicsConfigurationId'] as int,
      vmcWidthMm: (json['vmcWidthMm'] as num?)?.toDouble() ?? 670,
      vmcHeightMm: (json['vmcHeightMm'] as num?)?.toDouble() ?? 1260,
      vmcDepthMm: (json['vmcDepthMm'] as num?)?.toDouble() ?? 540,
      drawerHeight: (json['drawerHeight'] as num?)?.toDouble() ?? 125,
      contentHeight: (json['contentHeight'] as num?)?.toDouble() ?? 115,
      contentWidth: (json['contentWidth'] as num?)?.toDouble() ?? 75,
    );

Map<String, dynamic> _$VmcPhysicsConfigurationToJson(
        VmcPhysicsConfiguration instance) =>
    <String, dynamic>{
      'vmcPhysicsConfigurationId': instance.vmcPhysicsConfigurationId,
      'vmcWidthMm': instance.vmcWidthMm,
      'vmcHeightMm': instance.vmcHeightMm,
      'vmcDepthMm': instance.vmcDepthMm,
      'drawerHeight': instance.drawerHeight,
      'contentHeight': instance.contentHeight,
      'contentWidth': instance.contentWidth,
    };
