// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_physics_configuration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemPhysicsConfigurationCWProxy {
  ItemPhysicsConfiguration depthMm(double depthMm);

  ItemPhysicsConfiguration heightMm(double heightMm);

  ItemPhysicsConfiguration itemPhysicsId(int itemPhysicsId);

  ItemPhysicsConfiguration json(dynamic json);

  ItemPhysicsConfiguration widthMm(double widthMm);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemPhysicsConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemPhysicsConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemPhysicsConfiguration call({
    double? depthMm,
    double? heightMm,
    int? itemPhysicsId,
    dynamic? json,
    double? widthMm,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItemPhysicsConfiguration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItemPhysicsConfiguration.copyWith.fieldName(...)`
class _$ItemPhysicsConfigurationCWProxyImpl
    implements _$ItemPhysicsConfigurationCWProxy {
  final ItemPhysicsConfiguration _value;

  const _$ItemPhysicsConfigurationCWProxyImpl(this._value);

  @override
  ItemPhysicsConfiguration depthMm(double depthMm) => this(depthMm: depthMm);

  @override
  ItemPhysicsConfiguration heightMm(double heightMm) =>
      this(heightMm: heightMm);

  @override
  ItemPhysicsConfiguration itemPhysicsId(int itemPhysicsId) =>
      this(itemPhysicsId: itemPhysicsId);

  @override
  ItemPhysicsConfiguration json(dynamic json) => this(json: json);

  @override
  ItemPhysicsConfiguration widthMm(double widthMm) => this(widthMm: widthMm);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemPhysicsConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemPhysicsConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemPhysicsConfiguration call({
    Object? depthMm = const $CopyWithPlaceholder(),
    Object? heightMm = const $CopyWithPlaceholder(),
    Object? itemPhysicsId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? widthMm = const $CopyWithPlaceholder(),
  }) {
    return ItemPhysicsConfiguration(
      depthMm: depthMm == const $CopyWithPlaceholder() || depthMm == null
          ? _value.depthMm
          // ignore: cast_nullable_to_non_nullable
          : depthMm as double,
      heightMm: heightMm == const $CopyWithPlaceholder() || heightMm == null
          ? _value.heightMm
          // ignore: cast_nullable_to_non_nullable
          : heightMm as double,
      itemPhysicsId:
          itemPhysicsId == const $CopyWithPlaceholder() || itemPhysicsId == null
              ? _value.itemPhysicsId
              // ignore: cast_nullable_to_non_nullable
              : itemPhysicsId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      widthMm: widthMm == const $CopyWithPlaceholder() || widthMm == null
          ? _value.widthMm
          // ignore: cast_nullable_to_non_nullable
          : widthMm as double,
    );
  }
}

extension $ItemPhysicsConfigurationCopyWith on ItemPhysicsConfiguration {
  /// Returns a callable class that can be used as follows: `instanceOfItemPhysicsConfiguration.copyWith(...)` or like so:`instanceOfItemPhysicsConfiguration.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemPhysicsConfigurationCWProxy get copyWith =>
      _$ItemPhysicsConfigurationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPhysicsConfiguration _$ItemPhysicsConfigurationFromJson(
        Map<String, dynamic> json) =>
    ItemPhysicsConfiguration(
      itemPhysicsId: json['itemPhysicsId'] as int,
      widthMm: (json['widthMm'] as num?)?.toDouble() ?? 50,
      heightMm: (json['heightMm'] as num?)?.toDouble() ?? 50,
      depthMm: (json['depthMm'] as num?)?.toDouble() ?? 10,
    );

Map<String, dynamic> _$ItemPhysicsConfigurationToJson(
        ItemPhysicsConfiguration instance) =>
    <String, dynamic>{
      'itemPhysicsId': instance.itemPhysicsId,
      'widthMm': instance.widthMm,
      'heightMm': instance.heightMm,
      'depthMm': instance.depthMm,
    };
