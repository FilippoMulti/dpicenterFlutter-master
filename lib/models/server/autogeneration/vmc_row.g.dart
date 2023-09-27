// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_row.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcRowCWProxy {
  VmcRow id(int id);

  VmcRow json(dynamic json);

  VmcRow maxWidthSpaces(int maxWidthSpaces);

  VmcRow rowIndex(int rowIndex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcRow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcRow(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcRow call({
    int? id,
    dynamic? json,
    int? maxWidthSpaces,
    int? rowIndex,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcRow.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcRow.copyWith.fieldName(...)`
class _$VmcRowCWProxyImpl implements _$VmcRowCWProxy {
  final VmcRow _value;

  const _$VmcRowCWProxyImpl(this._value);

  @override
  VmcRow id(int id) => this(id: id);

  @override
  VmcRow json(dynamic json) => this(json: json);

  @override
  VmcRow maxWidthSpaces(int maxWidthSpaces) =>
      this(maxWidthSpaces: maxWidthSpaces);

  @override
  VmcRow rowIndex(int rowIndex) => this(rowIndex: rowIndex);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcRow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcRow(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcRow call({
    Object? id = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? maxWidthSpaces = const $CopyWithPlaceholder(),
    Object? rowIndex = const $CopyWithPlaceholder(),
  }) {
    return VmcRow(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      maxWidthSpaces: maxWidthSpaces == const $CopyWithPlaceholder() ||
              maxWidthSpaces == null
          ? _value.maxWidthSpaces
          // ignore: cast_nullable_to_non_nullable
          : maxWidthSpaces as int,
      rowIndex: rowIndex == const $CopyWithPlaceholder() || rowIndex == null
          ? _value.rowIndex
          // ignore: cast_nullable_to_non_nullable
          : rowIndex as int,
    );
  }
}

extension $VmcRowCopyWith on VmcRow {
  /// Returns a callable class that can be used as follows: `instanceOfVmcRow.copyWith(...)` or like so:`instanceOfVmcRow.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcRowCWProxy get copyWith => _$VmcRowCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcRow _$VmcRowFromJson(Map<String, dynamic> json) => VmcRow(
      id: json['id'] as int,
      rowIndex: json['rowIndex'] as int,
      maxWidthSpaces: json['maxWidthSpaces'] as int,
    )
      ..spaces = (json['spaces'] as List<dynamic>)
          .map((e) => Space.fromJson(e as Map<String, dynamic>))
          .toList()
      ..ticks = (json['ticks'] as List<dynamic>)
          .map((e) => Space.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$VmcRowToJson(VmcRow instance) => <String, dynamic>{
      'maxWidthSpaces': instance.maxWidthSpaces,
      'id': instance.id,
      'rowIndex': instance.rowIndex,
      'spaces': instance.spaces,
      'ticks': instance.ticks,
    };
