// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MediaItemCWProxy {
  MediaItem compressionId(int? compressionId);

  MediaItem description(String? description);

  MediaItem json(dynamic json);

  MediaItem media(Media? media);

  MediaItem mediaId(int mediaId);

  MediaItem mediaItemId(int mediaItemId);

  MediaItem parentId(int parentId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MediaItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaItem(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaItem call({
    int? compressionId,
    String? description,
    dynamic? json,
    Media? media,
    int? mediaId,
    int? mediaItemId,
    int? parentId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMediaItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMediaItem.copyWith.fieldName(...)`
class _$MediaItemCWProxyImpl implements _$MediaItemCWProxy {
  final MediaItem _value;

  const _$MediaItemCWProxyImpl(this._value);

  @override
  MediaItem compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  MediaItem description(String? description) => this(description: description);

  @override
  MediaItem json(dynamic json) => this(json: json);

  @override
  MediaItem media(Media? media) => this(media: media);

  @override
  MediaItem mediaId(int mediaId) => this(mediaId: mediaId);

  @override
  MediaItem mediaItemId(int mediaItemId) => this(mediaItemId: mediaItemId);

  @override
  MediaItem parentId(int parentId) => this(parentId: parentId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MediaItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaItem(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaItem call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? media = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? mediaItemId = const $CopyWithPlaceholder(),
    Object? parentId = const $CopyWithPlaceholder(),
  }) {
    return MediaItem(
      compressionId: compressionId == const $CopyWithPlaceholder()
          ? _value.compressionId
          // ignore: cast_nullable_to_non_nullable
          : compressionId as int?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      media: media == const $CopyWithPlaceholder()
          ? _value.media
          // ignore: cast_nullable_to_non_nullable
          : media as Media?,
      mediaId: mediaId == const $CopyWithPlaceholder() || mediaId == null
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int,
      mediaItemId:
          mediaItemId == const $CopyWithPlaceholder() || mediaItemId == null
              ? _value.mediaItemId
              // ignore: cast_nullable_to_non_nullable
              : mediaItemId as int,
      parentId: parentId == const $CopyWithPlaceholder() || parentId == null
          ? _value.parentId
          // ignore: cast_nullable_to_non_nullable
          : parentId as int,
    );
  }
}

extension $MediaItemCopyWith on MediaItem {
  /// Returns a callable class that can be used as follows: `instanceOfMediaItem.copyWith(...)` or like so:`instanceOfMediaItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MediaItemCWProxy get copyWith => _$MediaItemCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `MediaItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaItem(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  MediaItem copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool media = false,
  }) {
    return MediaItem(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      json: json,
      media: media == true ? null : this.media,
      mediaId: mediaId,
      mediaItemId: mediaItemId,
      parentId: parentId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaItem _$MediaItemFromJson(Map<String, dynamic> json) => MediaItem(
      mediaItemId: json['mediaItemId'] as int,
      parentId: json['parentId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      media: json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaItemToJson(MediaItem instance) => <String, dynamic>{
      'mediaItemId': instance.mediaItemId,
      'parentId': instance.parentId,
      'mediaId': instance.mediaId,
      'media': instance.media,
      'description': instance.description,
    };
