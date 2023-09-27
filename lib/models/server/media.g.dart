// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MediaCWProxy {
  Media bytes(Uint8List? bytes);

  Media compressionId(int? compressionId);

  Media content(String? content);

  Media description(String? description);

  Media file(PlatformFile? file);

  Media json(dynamic json);

  Media mediaId(int? mediaId);

  Media name(String name);

  Media previewBytes(Uint8List? previewBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Media(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Media(...).copyWith(id: 12, name: "My name")
  /// ````
  Media call({
    Uint8List? bytes,
    int? compressionId,
    String? content,
    String? description,
    PlatformFile? file,
    dynamic? json,
    int? mediaId,
    String? name,
    Uint8List? previewBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMedia.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMedia.copyWith.fieldName(...)`
class _$MediaCWProxyImpl implements _$MediaCWProxy {
  final Media _value;

  const _$MediaCWProxyImpl(this._value);

  @override
  Media bytes(Uint8List? bytes) => this(bytes: bytes);

  @override
  Media compressionId(int? compressionId) => this(compressionId: compressionId);

  @override
  Media content(String? content) => this(content: content);

  @override
  Media description(String? description) => this(description: description);

  @override
  Media file(PlatformFile? file) => this(file: file);

  @override
  Media json(dynamic json) => this(json: json);

  @override
  Media mediaId(int? mediaId) => this(mediaId: mediaId);

  @override
  Media name(String name) => this(name: name);

  @override
  Media previewBytes(Uint8List? previewBytes) =>
      this(previewBytes: previewBytes);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Media(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Media(...).copyWith(id: 12, name: "My name")
  /// ````
  Media call({
    Object? bytes = const $CopyWithPlaceholder(),
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? previewBytes = const $CopyWithPlaceholder(),
  }) {
    return Media(
      bytes: bytes == const $CopyWithPlaceholder()
          ? _value.bytes
          // ignore: cast_nullable_to_non_nullable
          : bytes as Uint8List?,
      compressionId: compressionId == const $CopyWithPlaceholder()
          ? _value.compressionId
          // ignore: cast_nullable_to_non_nullable
          : compressionId as int?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      file: file == const $CopyWithPlaceholder()
          ? _value.file
          // ignore: cast_nullable_to_non_nullable
          : file as PlatformFile?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      mediaId: mediaId == const $CopyWithPlaceholder()
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      previewBytes: previewBytes == const $CopyWithPlaceholder()
          ? _value.previewBytes
          // ignore: cast_nullable_to_non_nullable
          : previewBytes as Uint8List?,
    );
  }
}

extension $MediaCopyWith on Media {
  /// Returns a callable class that can be used as follows: `instanceOfMedia.copyWith(...)` or like so:`instanceOfMedia.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MediaCWProxy get copyWith => _$MediaCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Media(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Media(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Media copyWithNull({
    bool bytes = false,
    bool compressionId = false,
    bool content = false,
    bool description = false,
    bool file = false,
    bool mediaId = false,
    bool previewBytes = false,
  }) {
    return Media(
      bytes: bytes == true ? null : this.bytes,
      compressionId: compressionId == true ? null : this.compressionId,
      content: content == true ? null : this.content,
      description: description == true ? null : this.description,
      file: file == true ? null : this.file,
      json: json,
      mediaId: mediaId == true ? null : this.mediaId,
      name: name,
      previewBytes: previewBytes == true ? null : this.previewBytes,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      mediaId: json['mediaId'] as int?,
      content: json['content'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'mediaId': instance.mediaId,
      'content': instance.content,
      'name': instance.name,
      'description': instance.description,
    };
