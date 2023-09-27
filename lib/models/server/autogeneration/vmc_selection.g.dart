// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_selection.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcSelectionCWProxy {
  VmcSelection doubleEngine(bool doubleEngine);

  VmcSelection itemId(int itemId);

  VmcSelection json(dynamic json);

  VmcSelection singleEngine(bool singleEngine);

  VmcSelection steps(int steps);

  VmcSelection vmcId(int vmcId);

  VmcSelection vmcSelectionId(int vmcSelectionId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSelection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSelection(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSelection call({
    bool? doubleEngine,
    int? itemId,
    dynamic? json,
    bool? singleEngine,
    int? steps,
    int? vmcId,
    int? vmcSelectionId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcSelection.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcSelection.copyWith.fieldName(...)`
class _$VmcSelectionCWProxyImpl implements _$VmcSelectionCWProxy {
  final VmcSelection _value;

  const _$VmcSelectionCWProxyImpl(this._value);

  @override
  VmcSelection doubleEngine(bool doubleEngine) =>
      this(doubleEngine: doubleEngine);

  @override
  VmcSelection itemId(int itemId) => this(itemId: itemId);

  @override
  VmcSelection json(dynamic json) => this(json: json);

  @override
  VmcSelection singleEngine(bool singleEngine) =>
      this(singleEngine: singleEngine);

  @override
  VmcSelection steps(int steps) => this(steps: steps);

  @override
  VmcSelection vmcId(int vmcId) => this(vmcId: vmcId);

  @override
  VmcSelection vmcSelectionId(int vmcSelectionId) =>
      this(vmcSelectionId: vmcSelectionId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcSelection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcSelection(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcSelection call({
    Object? doubleEngine = const $CopyWithPlaceholder(),
    Object? itemId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? singleEngine = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
    Object? vmcSelectionId = const $CopyWithPlaceholder(),
  }) {
    return VmcSelection(
      doubleEngine:
          doubleEngine == const $CopyWithPlaceholder() || doubleEngine == null
              ? _value.doubleEngine
              // ignore: cast_nullable_to_non_nullable
              : doubleEngine as bool,
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      singleEngine:
          singleEngine == const $CopyWithPlaceholder() || singleEngine == null
              ? _value.singleEngine
              // ignore: cast_nullable_to_non_nullable
              : singleEngine as bool,
      steps: steps == const $CopyWithPlaceholder() || steps == null
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as int,
      vmcId: vmcId == const $CopyWithPlaceholder() || vmcId == null
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int,
      vmcSelectionId: vmcSelectionId == const $CopyWithPlaceholder() ||
              vmcSelectionId == null
          ? _value.vmcSelectionId
          // ignore: cast_nullable_to_non_nullable
          : vmcSelectionId as int,
    );
  }
}

extension $VmcSelectionCopyWith on VmcSelection {
  /// Returns a callable class that can be used as follows: `instanceOfVmcSelection.copyWith(...)` or like so:`instanceOfVmcSelection.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcSelectionCWProxy get copyWith => _$VmcSelectionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcSelection _$VmcSelectionFromJson(Map<String, dynamic> json) => VmcSelection(
      itemId: json['itemId'] as int,
      vmcSelectionId: json['vmcSelectionId'] as int,
      vmcId: json['vmcId'] as int,
      steps: json['steps'] as int? ?? 9,
      singleEngine: json['singleEngine'] as bool? ?? true,
      doubleEngine: json['doubleEngine'] as bool? ?? true,
    );

Map<String, dynamic> _$VmcSelectionToJson(VmcSelection instance) =>
    <String, dynamic>{
      'vmcSelectionId': instance.vmcSelectionId,
      'vmcId': instance.vmcId,
      'steps': instance.steps,
      'singleEngine': instance.singleEngine,
      'doubleEngine': instance.doubleEngine,
      'itemId': instance.itemId,
    };
