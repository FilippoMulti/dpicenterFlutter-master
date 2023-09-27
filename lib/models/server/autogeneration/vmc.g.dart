// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcCWProxy {
  Vmc code(String code);

  Vmc description(String description);

  Vmc json(dynamic json);

  Vmc rows(List<VmcRow>? rows);

  Vmc vmcAccessory(List<VmcAccessory>? vmcAccessory);

  Vmc vmcConfiguration(VmcConfiguration? vmcConfiguration);

  Vmc vmcConfigurationId(int? vmcConfigurationId);

  Vmc vmcEngines(List<VmcEngine>? vmcEngines);

  Vmc vmcFiles(List<VmcFile>? vmcFiles);

  Vmc vmcId(int vmcId);

  Vmc vmcPhysicsConfiguration(VmcPhysicsConfiguration? vmcPhysicsConfiguration);

  Vmc vmcPhysicsConfigurationId(int? vmcPhysicsConfigurationId);

  Vmc vmcProductions(List<VmcProduction>? vmcProductions);

  Vmc vmcSelections(List<VmcSelection>? vmcSelections);

  Vmc vmcSeparators(List<VmcSeparator>? vmcSeparators);

  Vmc vmcSettings(List<VmcSetting>? vmcSettings);

  Vmc vmcType(VmcTypeEnum? vmcType);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Vmc(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Vmc(...).copyWith(id: 12, name: "My name")
  /// ````
  Vmc call({
    String? code,
    String? description,
    dynamic? json,
    List<VmcRow>? rows,
    List<VmcAccessory>? vmcAccessory,
    VmcConfiguration? vmcConfiguration,
    int? vmcConfigurationId,
    List<VmcEngine>? vmcEngines,
    List<VmcFile>? vmcFiles,
    int? vmcId,
    VmcPhysicsConfiguration? vmcPhysicsConfiguration,
    int? vmcPhysicsConfigurationId,
    List<VmcProduction>? vmcProductions,
    List<VmcSelection>? vmcSelections,
    List<VmcSeparator>? vmcSeparators,
    List<VmcSetting>? vmcSettings,
    VmcTypeEnum? vmcType,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmc.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmc.copyWith.fieldName(...)`
class _$VmcCWProxyImpl implements _$VmcCWProxy {
  final Vmc _value;

  const _$VmcCWProxyImpl(this._value);

  @override
  Vmc code(String code) => this(code: code);

  @override
  Vmc description(String description) => this(description: description);

  @override
  Vmc json(dynamic json) => this(json: json);

  @override
  Vmc rows(List<VmcRow>? rows) => this(rows: rows);

  @override
  Vmc vmcAccessory(List<VmcAccessory>? vmcAccessory) =>
      this(vmcAccessory: vmcAccessory);

  @override
  Vmc vmcConfiguration(VmcConfiguration? vmcConfiguration) =>
      this(vmcConfiguration: vmcConfiguration);

  @override
  Vmc vmcConfigurationId(int? vmcConfigurationId) =>
      this(vmcConfigurationId: vmcConfigurationId);

  @override
  Vmc vmcEngines(List<VmcEngine>? vmcEngines) => this(vmcEngines: vmcEngines);

  @override
  Vmc vmcFiles(List<VmcFile>? vmcFiles) => this(vmcFiles: vmcFiles);

  @override
  Vmc vmcId(int vmcId) => this(vmcId: vmcId);

  @override
  Vmc vmcPhysicsConfiguration(
          VmcPhysicsConfiguration? vmcPhysicsConfiguration) =>
      this(vmcPhysicsConfiguration: vmcPhysicsConfiguration);

  @override
  Vmc vmcPhysicsConfigurationId(int? vmcPhysicsConfigurationId) =>
      this(vmcPhysicsConfigurationId: vmcPhysicsConfigurationId);

  @override
  Vmc vmcProductions(List<VmcProduction>? vmcProductions) =>
      this(vmcProductions: vmcProductions);

  @override
  Vmc vmcSelections(List<VmcSelection>? vmcSelections) =>
      this(vmcSelections: vmcSelections);

  @override
  Vmc vmcSeparators(List<VmcSeparator>? vmcSeparators) =>
      this(vmcSeparators: vmcSeparators);

  @override
  Vmc vmcSettings(List<VmcSetting>? vmcSettings) =>
      this(vmcSettings: vmcSettings);

  @override
  Vmc vmcType(VmcTypeEnum? vmcType) => this(vmcType: vmcType);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Vmc(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Vmc(...).copyWith(id: 12, name: "My name")
  /// ````
  Vmc call({
    Object? code = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? rows = const $CopyWithPlaceholder(),
    Object? vmcAccessory = const $CopyWithPlaceholder(),
    Object? vmcConfiguration = const $CopyWithPlaceholder(),
    Object? vmcConfigurationId = const $CopyWithPlaceholder(),
    Object? vmcEngines = const $CopyWithPlaceholder(),
    Object? vmcFiles = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
    Object? vmcPhysicsConfiguration = const $CopyWithPlaceholder(),
    Object? vmcPhysicsConfigurationId = const $CopyWithPlaceholder(),
    Object? vmcProductions = const $CopyWithPlaceholder(),
    Object? vmcSelections = const $CopyWithPlaceholder(),
    Object? vmcSeparators = const $CopyWithPlaceholder(),
    Object? vmcSettings = const $CopyWithPlaceholder(),
    Object? vmcType = const $CopyWithPlaceholder(),
  }) {
    return Vmc(
      code: code == const $CopyWithPlaceholder() || code == null
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      description:
          description == const $CopyWithPlaceholder() || description == null
              ? _value.description
              // ignore: cast_nullable_to_non_nullable
              : description as String,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      rows: rows == const $CopyWithPlaceholder()
          ? _value.rows
          // ignore: cast_nullable_to_non_nullable
          : rows as List<VmcRow>?,
      vmcAccessory: vmcAccessory == const $CopyWithPlaceholder()
          ? _value.vmcAccessory
          // ignore: cast_nullable_to_non_nullable
          : vmcAccessory as List<VmcAccessory>?,
      vmcConfiguration: vmcConfiguration == const $CopyWithPlaceholder()
          ? _value.vmcConfiguration
          // ignore: cast_nullable_to_non_nullable
          : vmcConfiguration as VmcConfiguration?,
      vmcConfigurationId: vmcConfigurationId == const $CopyWithPlaceholder()
          ? _value.vmcConfigurationId
          // ignore: cast_nullable_to_non_nullable
          : vmcConfigurationId as int?,
      vmcEngines: vmcEngines == const $CopyWithPlaceholder()
          ? _value.vmcEngines
          // ignore: cast_nullable_to_non_nullable
          : vmcEngines as List<VmcEngine>?,
      vmcFiles: vmcFiles == const $CopyWithPlaceholder()
          ? _value.vmcFiles
          // ignore: cast_nullable_to_non_nullable
          : vmcFiles as List<VmcFile>?,
      vmcId: vmcId == const $CopyWithPlaceholder() || vmcId == null
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int,
      vmcPhysicsConfiguration:
          vmcPhysicsConfiguration == const $CopyWithPlaceholder()
              ? _value.vmcPhysicsConfiguration
              // ignore: cast_nullable_to_non_nullable
              : vmcPhysicsConfiguration as VmcPhysicsConfiguration?,
      vmcPhysicsConfigurationId:
          vmcPhysicsConfigurationId == const $CopyWithPlaceholder()
              ? _value.vmcPhysicsConfigurationId
              // ignore: cast_nullable_to_non_nullable
              : vmcPhysicsConfigurationId as int?,
      vmcProductions: vmcProductions == const $CopyWithPlaceholder()
          ? _value.vmcProductions
          // ignore: cast_nullable_to_non_nullable
          : vmcProductions as List<VmcProduction>?,
      vmcSelections: vmcSelections == const $CopyWithPlaceholder()
          ? _value.vmcSelections
          // ignore: cast_nullable_to_non_nullable
          : vmcSelections as List<VmcSelection>?,
      vmcSeparators: vmcSeparators == const $CopyWithPlaceholder()
          ? _value.vmcSeparators
          // ignore: cast_nullable_to_non_nullable
          : vmcSeparators as List<VmcSeparator>?,
      vmcSettings: vmcSettings == const $CopyWithPlaceholder()
          ? _value.vmcSettings
          // ignore: cast_nullable_to_non_nullable
          : vmcSettings as List<VmcSetting>?,
      vmcType: vmcType == const $CopyWithPlaceholder()
          ? _value.vmcType
          // ignore: cast_nullable_to_non_nullable
          : vmcType as VmcTypeEnum?,
    );
  }
}

extension $VmcCopyWith on Vmc {
  /// Returns a callable class that can be used as follows: `instanceOfVmc.copyWith(...)` or like so:`instanceOfVmc.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcCWProxy get copyWith => _$VmcCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Vmc(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Vmc(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Vmc copyWithNull({
    bool rows = false,
    bool vmcAccessory = false,
    bool vmcConfiguration = false,
    bool vmcConfigurationId = false,
    bool vmcEngines = false,
    bool vmcFiles = false,
    bool vmcPhysicsConfiguration = false,
    bool vmcPhysicsConfigurationId = false,
    bool vmcProductions = false,
    bool vmcSelections = false,
    bool vmcSeparators = false,
    bool vmcSettings = false,
    bool vmcType = false,
  }) {
    return Vmc(
      code: code,
      description: description,
      json: json,
      rows: rows == true ? null : this.rows,
      vmcAccessory: vmcAccessory == true ? null : this.vmcAccessory,
      vmcConfiguration: vmcConfiguration == true ? null : this.vmcConfiguration,
      vmcConfigurationId:
          vmcConfigurationId == true ? null : this.vmcConfigurationId,
      vmcEngines: vmcEngines == true ? null : this.vmcEngines,
      vmcFiles: vmcFiles == true ? null : this.vmcFiles,
      vmcId: vmcId,
      vmcPhysicsConfiguration:
          vmcPhysicsConfiguration == true ? null : this.vmcPhysicsConfiguration,
      vmcPhysicsConfigurationId: vmcPhysicsConfigurationId == true
          ? null
          : this.vmcPhysicsConfigurationId,
      vmcProductions: vmcProductions == true ? null : this.vmcProductions,
      vmcSelections: vmcSelections == true ? null : this.vmcSelections,
      vmcSeparators: vmcSeparators == true ? null : this.vmcSeparators,
      vmcSettings: vmcSettings == true ? null : this.vmcSettings,
      vmcType: vmcType == true ? null : this.vmcType,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vmc _$VmcFromJson(Map<String, dynamic> json) => Vmc(
      vmcId: json['vmcId'] as int,
      code: json['code'] as String,
      description: json['description'] as String,
      vmcPhysicsConfigurationId: json['vmcPhysicsConfigurationId'] as int?,
      vmcPhysicsConfiguration: json['vmcPhysicsConfiguration'] == null
          ? null
          : VmcPhysicsConfiguration.fromJson(
              json['vmcPhysicsConfiguration'] as Map<String, dynamic>),
      vmcConfigurationId: json['vmcConfigurationId'] as int?,
      vmcConfiguration: json['vmcConfiguration'] == null
          ? null
          : VmcConfiguration.fromJson(
              json['vmcConfiguration'] as Map<String, dynamic>),
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => VmcRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcSelections: (json['vmcSelections'] as List<dynamic>?)
          ?.map((e) => VmcSelection.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcEngines: (json['vmcEngines'] as List<dynamic>?)
          ?.map((e) => VmcEngine.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcAccessory: (json['vmcAccessory'] as List<dynamic>?)
          ?.map((e) => VmcAccessory.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcSeparators: (json['vmcSeparators'] as List<dynamic>?)
          ?.map((e) => VmcSeparator.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcSettings: (json['vmcSettings'] as List<dynamic>?)
          ?.map((e) => VmcSetting.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcProductions: (json['vmcProductions'] as List<dynamic>?)
          ?.map((e) => VmcProduction.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcFiles: (json['vmcFiles'] as List<dynamic>?)
          ?.map((e) => VmcFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      vmcType: $enumDecodeNullable(_$VmcTypeEnumEnumMap, json['vmcType']),
    );

Map<String, dynamic> _$VmcToJson(Vmc instance) => <String, dynamic>{
      'vmcId': instance.vmcId,
      'code': instance.code,
      'description': instance.description,
      'vmcPhysicsConfigurationId': instance.vmcPhysicsConfigurationId,
      'vmcPhysicsConfiguration': instance.vmcPhysicsConfiguration,
      'vmcConfigurationId': instance.vmcConfigurationId,
      'vmcConfiguration': instance.vmcConfiguration,
      'vmcSeparators': instance.vmcSeparators,
      'vmcEngines': instance.vmcEngines,
      'vmcAccessory': instance.vmcAccessory,
      'vmcSelections': instance.vmcSelections,
      'vmcSettings': instance.vmcSettings,
      'vmcFiles': instance.vmcFiles,
      'vmcProductions': instance.vmcProductions,
      'rows': instance.rows,
      'vmcType': _$VmcTypeEnumEnumMap[instance.vmcType],
    };

const _$VmcTypeEnumEnumMap = {
  VmcTypeEnum.vendingMachine: 0,
  VmcTypeEnum.other: 1,
};
