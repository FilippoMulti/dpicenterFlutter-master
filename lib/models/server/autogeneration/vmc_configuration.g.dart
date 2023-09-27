// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_configuration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcConfigurationCWProxy {
  VmcConfiguration doubleEngineRotationVerse(int doubleEngineRotationVerse);

  VmcConfiguration json(dynamic json);

  VmcConfiguration maxRows(int maxRows);

  VmcConfiguration maxWidthSpaces(int maxWidthSpaces);

  VmcConfiguration singleEngineRotationVerse(int singleEngineRotationVerse);

  VmcConfiguration tickInSingleSpace(int tickInSingleSpace);

  VmcConfiguration vmcConfigurationId(int vmcConfigurationId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcConfiguration call({
    int? doubleEngineRotationVerse,
    dynamic? json,
    int? maxRows,
    int? maxWidthSpaces,
    int? singleEngineRotationVerse,
    int? tickInSingleSpace,
    int? vmcConfigurationId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcConfiguration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcConfiguration.copyWith.fieldName(...)`
class _$VmcConfigurationCWProxyImpl implements _$VmcConfigurationCWProxy {
  final VmcConfiguration _value;

  const _$VmcConfigurationCWProxyImpl(this._value);

  @override
  VmcConfiguration doubleEngineRotationVerse(int doubleEngineRotationVerse) =>
      this(doubleEngineRotationVerse: doubleEngineRotationVerse);

  @override
  VmcConfiguration json(dynamic json) => this(json: json);

  @override
  VmcConfiguration maxRows(int maxRows) => this(maxRows: maxRows);

  @override
  VmcConfiguration maxWidthSpaces(int maxWidthSpaces) =>
      this(maxWidthSpaces: maxWidthSpaces);

  @override
  VmcConfiguration singleEngineRotationVerse(int singleEngineRotationVerse) =>
      this(singleEngineRotationVerse: singleEngineRotationVerse);

  @override
  VmcConfiguration tickInSingleSpace(int tickInSingleSpace) =>
      this(tickInSingleSpace: tickInSingleSpace);

  @override
  VmcConfiguration vmcConfigurationId(int vmcConfigurationId) =>
      this(vmcConfigurationId: vmcConfigurationId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcConfiguration call({
    Object? doubleEngineRotationVerse = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? maxRows = const $CopyWithPlaceholder(),
    Object? maxWidthSpaces = const $CopyWithPlaceholder(),
    Object? singleEngineRotationVerse = const $CopyWithPlaceholder(),
    Object? tickInSingleSpace = const $CopyWithPlaceholder(),
    Object? vmcConfigurationId = const $CopyWithPlaceholder(),
  }) {
    return VmcConfiguration(
      doubleEngineRotationVerse:
          doubleEngineRotationVerse == const $CopyWithPlaceholder() ||
                  doubleEngineRotationVerse == null
              ? _value.doubleEngineRotationVerse
              // ignore: cast_nullable_to_non_nullable
              : doubleEngineRotationVerse as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      maxRows: maxRows == const $CopyWithPlaceholder() || maxRows == null
          ? _value.maxRows
          // ignore: cast_nullable_to_non_nullable
          : maxRows as int,
      maxWidthSpaces: maxWidthSpaces == const $CopyWithPlaceholder() ||
              maxWidthSpaces == null
          ? _value.maxWidthSpaces
          // ignore: cast_nullable_to_non_nullable
          : maxWidthSpaces as int,
      singleEngineRotationVerse:
          singleEngineRotationVerse == const $CopyWithPlaceholder() ||
                  singleEngineRotationVerse == null
              ? _value.singleEngineRotationVerse
              // ignore: cast_nullable_to_non_nullable
              : singleEngineRotationVerse as int,
      tickInSingleSpace: tickInSingleSpace == const $CopyWithPlaceholder() ||
              tickInSingleSpace == null
          ? _value.tickInSingleSpace
          // ignore: cast_nullable_to_non_nullable
          : tickInSingleSpace as int,
      vmcConfigurationId: vmcConfigurationId == const $CopyWithPlaceholder() ||
              vmcConfigurationId == null
          ? _value.vmcConfigurationId
          // ignore: cast_nullable_to_non_nullable
          : vmcConfigurationId as int,
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
      vmcConfigurationId: json['vmcConfigurationId'] as int,
      maxRows: json['maxRows'] as int? ?? 8,
      maxWidthSpaces: json['maxWidthSpaces'] as int? ?? 9,
      tickInSingleSpace: json['tickInSingleSpace'] as int? ?? 4,
      singleEngineRotationVerse: json['singleEngineRotationVerse'] as int? ?? 0,
      doubleEngineRotationVerse: json['doubleEngineRotationVerse'] as int? ?? 0,
    );

Map<String, dynamic> _$VmcConfigurationToJson(VmcConfiguration instance) =>
    <String, dynamic>{
      'vmcConfigurationId': instance.vmcConfigurationId,
      'maxRows': instance.maxRows,
      'maxWidthSpaces': instance.maxWidthSpaces,
      'tickInSingleSpace': instance.tickInSingleSpace,
      'singleEngineRotationVerse': instance.singleEngineRotationVerse,
      'doubleEngineRotationVerse': instance.doubleEngineRotationVerse,
    };
