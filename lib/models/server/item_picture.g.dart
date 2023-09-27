// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_picture.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemPictureCWProxy {
  ItemPicture compressionId(int? compressionId);

  ItemPicture description(String? description);

  ItemPicture itemId(int itemId);

  ItemPicture itemPictureId(int itemPictureId);

  ItemPicture json(dynamic json);

  ItemPicture mediaId(int mediaId);

  ItemPicture picture(Media? picture);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemPicture call({
    int? compressionId,
    String? description,
    int? itemId,
    int? itemPictureId,
    dynamic? json,
    int? mediaId,
    Media? picture,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItemPicture.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItemPicture.copyWith.fieldName(...)`
class _$ItemPictureCWProxyImpl implements _$ItemPictureCWProxy {
  final ItemPicture _value;

  const _$ItemPictureCWProxyImpl(this._value);

  @override
  ItemPicture compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  ItemPicture description(String? description) =>
      this(description: description);

  @override
  ItemPicture itemId(int itemId) => this(itemId: itemId);

  @override
  ItemPicture itemPictureId(int itemPictureId) =>
      this(itemPictureId: itemPictureId);

  @override
  ItemPicture json(dynamic json) => this(json: json);

  @override
  ItemPicture mediaId(int mediaId) => this(mediaId: mediaId);

  @override
  ItemPicture picture(Media? picture) => this(picture: picture);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemPicture call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? itemId = const $CopyWithPlaceholder(),
    Object? itemPictureId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? picture = const $CopyWithPlaceholder(),
  }) {
    return ItemPicture(
      compressionId: compressionId == const $CopyWithPlaceholder()
          ? _value.compressionId
          // ignore: cast_nullable_to_non_nullable
          : compressionId as int?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      itemId: itemId == const $CopyWithPlaceholder() || itemId == null
          ? _value.itemId
          // ignore: cast_nullable_to_non_nullable
          : itemId as int,
      itemPictureId:
          itemPictureId == const $CopyWithPlaceholder() || itemPictureId == null
              ? _value.itemPictureId
              // ignore: cast_nullable_to_non_nullable
              : itemPictureId as int,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      mediaId: mediaId == const $CopyWithPlaceholder() || mediaId == null
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int,
      picture: picture == const $CopyWithPlaceholder()
          ? _value.picture
          // ignore: cast_nullable_to_non_nullable
          : picture as Media?,
    );
  }
}

extension $ItemPictureCopyWith on ItemPicture {
  /// Returns a callable class that can be used as follows: `instanceOfItemPicture.copyWith(...)` or like so:`instanceOfItemPicture.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemPictureCWProxy get copyWith => _$ItemPictureCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ItemPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemPicture(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ItemPicture copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool picture = false,
  }) {
    return ItemPicture(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      itemId: itemId,
      itemPictureId: itemPictureId,
      json: json,
      mediaId: mediaId,
      picture: picture == true ? null : this.picture,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPicture _$ItemPictureFromJson(Map<String, dynamic> json) => ItemPicture(
      itemPictureId: json['itemPictureId'] as int,
      itemId: json['itemId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      picture: json['picture'] == null
          ? null
          : Media.fromJson(json['picture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemPictureToJson(ItemPicture instance) =>
    <String, dynamic>{
      'itemPictureId': instance.itemPictureId,
      'itemId': instance.itemId,
      'mediaId': instance.mediaId,
      'picture': instance.picture,
      'description': instance.description,
    };
