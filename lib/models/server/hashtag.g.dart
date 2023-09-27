// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HashTagCWProxy {
  HashTag color(String? color);

  HashTag description(String? description);

  HashTag hashTagId(int? hashTagId);

  HashTag json(dynamic json);

  HashTag name(String? name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HashTag(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HashTag(...).copyWith(id: 12, name: "My name")
  /// ````
  HashTag call({
    String? color,
    String? description,
    int? hashTagId,
    dynamic? json,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHashTag.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHashTag.copyWith.fieldName(...)`
class _$HashTagCWProxyImpl implements _$HashTagCWProxy {
  final HashTag _value;

  const _$HashTagCWProxyImpl(this._value);

  @override
  HashTag color(String? color) => this(color: color);

  @override
  HashTag description(String? description) => this(description: description);

  @override
  HashTag hashTagId(int? hashTagId) => this(hashTagId: hashTagId);

  @override
  HashTag json(dynamic json) => this(json: json);

  @override
  HashTag name(String? name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HashTag(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HashTag(...).copyWith(id: 12, name: "My name")
  /// ````
  HashTag call({
    Object? color = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? hashTagId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return HashTag(
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      hashTagId: hashTagId == const $CopyWithPlaceholder()
          ? _value.hashTagId
          // ignore: cast_nullable_to_non_nullable
          : hashTagId as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $HashTagCopyWith on HashTag {
  /// Returns a callable class that can be used as follows: `instanceOfHashTag.copyWith(...)` or like so:`instanceOfHashTag.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HashTagCWProxy get copyWith => _$HashTagCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HashTag _$HashTagFromJson(Map<String, dynamic> json) => HashTag(
      hashTagId: json['hashTagId'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$HashTagToJson(HashTag instance) => <String, dynamic>{
      'hashTagId': instance.hashTagId,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
    };
