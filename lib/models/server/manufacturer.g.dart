// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manufacturer.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ManufacturerCWProxy {
  Manufacturer description(String? description);

  Manufacturer json(dynamic json);

  Manufacturer manufacturerId(int? manufacturerId);

  Manufacturer referente(String? referente);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Manufacturer(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Manufacturer(...).copyWith(id: 12, name: "My name")
  /// ````
  Manufacturer call({
    String? description,
    dynamic? json,
    int? manufacturerId,
    String? referente,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfManufacturer.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfManufacturer.copyWith.fieldName(...)`
class _$ManufacturerCWProxyImpl implements _$ManufacturerCWProxy {
  final Manufacturer _value;

  const _$ManufacturerCWProxyImpl(this._value);

  @override
  Manufacturer description(String? description) =>
      this(description: description);

  @override
  Manufacturer json(dynamic json) => this(json: json);

  @override
  Manufacturer manufacturerId(int? manufacturerId) =>
      this(manufacturerId: manufacturerId);

  @override
  Manufacturer referente(String? referente) => this(referente: referente);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Manufacturer(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Manufacturer(...).copyWith(id: 12, name: "My name")
  /// ````
  Manufacturer call({
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? manufacturerId = const $CopyWithPlaceholder(),
    Object? referente = const $CopyWithPlaceholder(),
  }) {
    return Manufacturer(
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      manufacturerId: manufacturerId == const $CopyWithPlaceholder()
          ? _value.manufacturerId
          // ignore: cast_nullable_to_non_nullable
          : manufacturerId as int?,
      referente: referente == const $CopyWithPlaceholder()
          ? _value.referente
          // ignore: cast_nullable_to_non_nullable
          : referente as String?,
    );
  }
}

extension $ManufacturerCopyWith on Manufacturer {
  /// Returns a callable class that can be used as follows: `instanceOfManufacturer.copyWith(...)` or like so:`instanceOfManufacturer.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ManufacturerCWProxy get copyWith => _$ManufacturerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manufacturer _$ManufacturerFromJson(Map<String, dynamic> json) => Manufacturer(
      manufacturerId: json['manufacturerId'] as int?,
      description: json['description'] as String?,
      referente: json['referente'] as String?,
    );

Map<String, dynamic> _$ManufacturerToJson(Manufacturer instance) =>
    <String, dynamic>{
      'manufacturerId': instance.manufacturerId,
      'description': instance.description,
      'referente': instance.referente,
    };
