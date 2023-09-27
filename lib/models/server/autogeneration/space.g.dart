// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SpaceCWProxy {
  Space id(int id);

  Space item(VmcItem? item);

  Space json(dynamic json);

  Space position(double? position);

  Space removed(bool removed);

  Space rowIndex(int rowIndex);

  Space tickInSingleSpace(int tickInSingleSpace);

  Space visible(bool visible);

  Space widthSpaces(double? widthSpaces);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Space(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Space(...).copyWith(id: 12, name: "My name")
  /// ````
  Space call({
    int? id,
    VmcItem? item,
    dynamic? json,
    double? position,
    bool? removed,
    int? rowIndex,
    int? tickInSingleSpace,
    bool? visible,
    double? widthSpaces,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSpace.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSpace.copyWith.fieldName(...)`
class _$SpaceCWProxyImpl implements _$SpaceCWProxy {
  final Space _value;

  const _$SpaceCWProxyImpl(this._value);

  @override
  Space id(int id) => this(id: id);

  @override
  Space item(VmcItem? item) => this(item: item);

  @override
  Space json(dynamic json) => this(json: json);

  @override
  Space position(double? position) => this(position: position);

  @override
  Space removed(bool removed) => this(removed: removed);

  @override
  Space rowIndex(int rowIndex) => this(rowIndex: rowIndex);

  @override
  Space tickInSingleSpace(int tickInSingleSpace) =>
      this(tickInSingleSpace: tickInSingleSpace);

  @override
  Space visible(bool visible) => this(visible: visible);

  @override
  Space widthSpaces(double? widthSpaces) => this(widthSpaces: widthSpaces);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Space(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Space(...).copyWith(id: 12, name: "My name")
  /// ````
  Space call({
    Object? id = const $CopyWithPlaceholder(),
    Object? item = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? removed = const $CopyWithPlaceholder(),
    Object? rowIndex = const $CopyWithPlaceholder(),
    Object? tickInSingleSpace = const $CopyWithPlaceholder(),
    Object? visible = const $CopyWithPlaceholder(),
    Object? widthSpaces = const $CopyWithPlaceholder(),
  }) {
    return Space(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as VmcItem?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      position: position == const $CopyWithPlaceholder()
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as double?,
      removed: removed == const $CopyWithPlaceholder() || removed == null
          ? _value.removed
          // ignore: cast_nullable_to_non_nullable
          : removed as bool,
      rowIndex: rowIndex == const $CopyWithPlaceholder() || rowIndex == null
          ? _value.rowIndex
          // ignore: cast_nullable_to_non_nullable
          : rowIndex as int,
      tickInSingleSpace: tickInSingleSpace == const $CopyWithPlaceholder() ||
              tickInSingleSpace == null
          ? _value.tickInSingleSpace
          // ignore: cast_nullable_to_non_nullable
          : tickInSingleSpace as int,
      visible: visible == const $CopyWithPlaceholder() || visible == null
          ? _value.visible
          // ignore: cast_nullable_to_non_nullable
          : visible as bool,
      widthSpaces: widthSpaces == const $CopyWithPlaceholder()
          ? _value.widthSpaces
          // ignore: cast_nullable_to_non_nullable
          : widthSpaces as double?,
    );
  }
}

extension $SpaceCopyWith on Space {
  /// Returns a callable class that can be used as follows: `instanceOfSpace.copyWith(...)` or like so:`instanceOfSpace.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SpaceCWProxy get copyWith => _$SpaceCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Space(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Space(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Space copyWithNull({
    bool item = false,
    bool position = false,
    bool widthSpaces = false,
  }) {
    return Space(
      id: id,
      item: item == true ? null : this.item,
      json: json,
      position: position == true ? null : this.position,
      removed: removed,
      rowIndex: rowIndex,
      tickInSingleSpace: tickInSingleSpace,
      visible: visible,
      widthSpaces: widthSpaces == true ? null : this.widthSpaces,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Space _$SpaceFromJson(Map<String, dynamic> json) => Space(
      id: json['id'] as int,
      position: (json['position'] as num?)?.toDouble(),
      item: json['item'] == null
          ? null
          : VmcItem.fromJson(json['item'] as Map<String, dynamic>),
      widthSpaces: (json['widthSpaces'] as num?)?.toDouble(),
      visible: json['visible'] as bool? ?? true,
      removed: json['removed'] as bool? ?? false,
      tickInSingleSpace: json['tickInSingleSpace'] as int? ?? 4,
      rowIndex: json['rowIndex'] as int,
    );

Map<String, dynamic> _$SpaceToJson(Space instance) => <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'item': instance.item,
      'tickInSingleSpace': instance.tickInSingleSpace,
      'visible': instance.visible,
      'rowIndex': instance.rowIndex,
      'removed': instance.removed,
      'widthSpaces': instance.widthSpaces,
    };
