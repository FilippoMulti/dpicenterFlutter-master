// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_item_picture.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SampleItemPictureCWProxy {
  SampleItemPicture compressionId(int? compressionId);

  SampleItemPicture description(String? description);

  SampleItemPicture json(dynamic json);

  SampleItemPicture mediaId(int mediaId);

  SampleItemPicture picture(Media? picture);

  SampleItemPicture sampleItemId(int sampleItemId);

  SampleItemPicture sampleItemPictureId(int sampleItemPictureId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItemPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItemPicture call({
    int? compressionId,
    String? description,
    dynamic? json,
    int? mediaId,
    Media? picture,
    int? sampleItemId,
    int? sampleItemPictureId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSampleItemPicture.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSampleItemPicture.copyWith.fieldName(...)`
class _$SampleItemPictureCWProxyImpl implements _$SampleItemPictureCWProxy {
  final SampleItemPicture _value;

  const _$SampleItemPictureCWProxyImpl(this._value);

  @override
  SampleItemPicture compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  SampleItemPicture description(String? description) =>
      this(description: description);

  @override
  SampleItemPicture json(dynamic json) => this(json: json);

  @override
  SampleItemPicture mediaId(int mediaId) => this(mediaId: mediaId);

  @override
  SampleItemPicture picture(Media? picture) => this(picture: picture);

  @override
  SampleItemPicture sampleItemId(int sampleItemId) =>
      this(sampleItemId: sampleItemId);

  @override
  SampleItemPicture sampleItemPictureId(int sampleItemPictureId) =>
      this(sampleItemPictureId: sampleItemPictureId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItemPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItemPicture call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? picture = const $CopyWithPlaceholder(),
    Object? sampleItemId = const $CopyWithPlaceholder(),
    Object? sampleItemPictureId = const $CopyWithPlaceholder(),
  }) {
    return SampleItemPicture(
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
      mediaId: mediaId == const $CopyWithPlaceholder() || mediaId == null
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int,
      picture: picture == const $CopyWithPlaceholder()
          ? _value.picture
          // ignore: cast_nullable_to_non_nullable
          : picture as Media?,
      sampleItemId:
          sampleItemId == const $CopyWithPlaceholder() || sampleItemId == null
              ? _value.sampleItemId
              // ignore: cast_nullable_to_non_nullable
              : sampleItemId as int,
      sampleItemPictureId:
          sampleItemPictureId == const $CopyWithPlaceholder() ||
                  sampleItemPictureId == null
              ? _value.sampleItemPictureId
              // ignore: cast_nullable_to_non_nullable
              : sampleItemPictureId as int,
    );
  }
}

extension $SampleItemPictureCopyWith on SampleItemPicture {
  /// Returns a callable class that can be used as follows: `instanceOfSampleItemPicture.copyWith(...)` or like so:`instanceOfSampleItemPicture.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SampleItemPictureCWProxy get copyWith =>
      _$SampleItemPictureCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `SampleItemPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemPicture(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  SampleItemPicture copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool picture = false,
  }) {
    return SampleItemPicture(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      json: json,
      mediaId: mediaId,
      picture: picture == true ? null : this.picture,
      sampleItemId: sampleItemId,
      sampleItemPictureId: sampleItemPictureId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleItemPicture _$SampleItemPictureFromJson(Map<String, dynamic> json) =>
    SampleItemPicture(
      sampleItemPictureId: json['sampleItemPictureId'] as int,
      sampleItemId: json['sampleItemId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      picture: json['picture'] == null
          ? null
          : Media.fromJson(json['picture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SampleItemPictureToJson(SampleItemPicture instance) =>
    <String, dynamic>{
      'sampleItemPictureId': instance.sampleItemPictureId,
      'sampleItemId': instance.sampleItemId,
      'mediaId': instance.mediaId,
      'picture': instance.picture,
      'description': instance.description,
    };
