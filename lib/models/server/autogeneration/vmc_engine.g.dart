// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_engine.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcEngineCWProxy {
  VmcEngine double(bool double);

  VmcEngine itemId(int itemId);

  VmcEngine json(dynamic json);

  VmcEngine single(bool single);

  VmcEngine vmcEngineId(int vmcEngineId);

  VmcEngine vmcId(int vmcId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcEngine(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcEngine(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcEngine call({
    bool? double,
    int? itemId,
    dynamic? json,
    bool? single,
    int? vmcEngineId,
    int? vmcId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcEngine.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcEngine.copyWith.fieldName(...)`
class _$VmcEngineCWProxyImpl implements _$VmcEngineCWProxy {
  final VmcEngine _value;

  const _$VmcEngineCWProxyImpl(this._value);

  @override
  VmcEngine double(bool double) => this(double: double);

  @override
  VmcEngine itemId(int itemId) => this(itemId: itemId);

  @override
  VmcEngine json(dynamic json) => this(json: json);

  @override
  VmcEngine single(bool single) => this(single: single);

  @override
  VmcEngine vmcEngineId(int vmcEngineId) => this(vmcEngineId: vmcEngineId);

  @override
  VmcEngine vmcId(int vmcId) => this(vmcId: vmcId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcEngine(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcEngine(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcEngine call({
    Object? double = const $CopyWithPlaceholder(),
    Object? itemId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? single = const $CopyWithPlaceholder(),
    Object? vmcEngineId = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
  }) {
    return VmcEngine(
      double: double == const $CopyWithPlaceholder() || double == null
          ? _value.double
          // ignore: cast_nullable_to_non_nullable
          : double as bool,
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      single: single == const $CopyWithPlaceholder() || single == null
          ? _value.single
          // ignore: cast_nullable_to_non_nullable
          : single as bool,
      vmcEngineId:
          vmcEngineId == const $CopyWithPlaceholder() || vmcEngineId == null
              ? _value.vmcEngineId
              // ignore: cast_nullable_to_non_nullable
              : vmcEngineId as int,
      vmcId: vmcId == const $CopyWithPlaceholder() || vmcId == null
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int,
    );
  }
}

extension $VmcEngineCopyWith on VmcEngine {
  /// Returns a callable class that can be used as follows: `instanceOfVmcEngine.copyWith(...)` or like so:`instanceOfVmcEngine.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcEngineCWProxy get copyWith => _$VmcEngineCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcEngine _$VmcEngineFromJson(Map<String, dynamic> json) => VmcEngine(
      vmcEngineId: json['vmcEngineId'] as int,
      vmcId: json['vmcId'] as int,
      itemId: json['itemId'] as int,
      single: json['single'] as bool? ?? false,
      double: json['double'] as bool? ?? false,
    );

Map<String, dynamic> _$VmcEngineToJson(VmcEngine instance) => <String, dynamic>{
      'vmcEngineId': instance.vmcEngineId,
      'vmcId': instance.vmcId,
      'itemId': instance.itemId,
      'single': instance.single,
      'double': instance.double,
    };
