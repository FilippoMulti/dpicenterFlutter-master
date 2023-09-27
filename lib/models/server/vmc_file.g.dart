// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vmc_file.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VmcFileCWProxy {
  VmcFile compressionId(int? compressionId);

  VmcFile description(String? description);

  VmcFile file(Media? file);

  VmcFile json(dynamic json);

  VmcFile mediaId(int mediaId);

  VmcFile vmcFileId(int vmcFileId);

  VmcFile vmcId(int vmcId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcFile(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcFile call({
    int? compressionId,
    String? description,
    Media? file,
    dynamic? json,
    int? mediaId,
    int? vmcFileId,
    int? vmcId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVmcFile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVmcFile.copyWith.fieldName(...)`
class _$VmcFileCWProxyImpl implements _$VmcFileCWProxy {
  final VmcFile _value;

  const _$VmcFileCWProxyImpl(this._value);

  @override
  VmcFile compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  VmcFile description(String? description) => this(description: description);

  @override
  VmcFile file(Media? file) => this(file: file);

  @override
  VmcFile json(dynamic json) => this(json: json);

  @override
  VmcFile mediaId(int mediaId) => this(mediaId: mediaId);

  @override
  VmcFile vmcFileId(int vmcFileId) => this(vmcFileId: vmcFileId);

  @override
  VmcFile vmcId(int vmcId) => this(vmcId: vmcId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VmcFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcFile(...).copyWith(id: 12, name: "My name")
  /// ````
  VmcFile call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? vmcFileId = const $CopyWithPlaceholder(),
    Object? vmcId = const $CopyWithPlaceholder(),
  }) {
    return VmcFile(
      compressionId: compressionId == const $CopyWithPlaceholder()
          ? _value.compressionId
          // ignore: cast_nullable_to_non_nullable
          : compressionId as int?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      file: file == const $CopyWithPlaceholder()
          ? _value.file
          // ignore: cast_nullable_to_non_nullable
          : file as Media?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      mediaId: mediaId == const $CopyWithPlaceholder() || mediaId == null
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int,
      vmcFileId: vmcFileId == const $CopyWithPlaceholder() || vmcFileId == null
          ? _value.vmcFileId
          // ignore: cast_nullable_to_non_nullable
          : vmcFileId as int,
      vmcId: vmcId == const $CopyWithPlaceholder() || vmcId == null
          ? _value.vmcId
          // ignore: cast_nullable_to_non_nullable
          : vmcId as int,
    );
  }
}

extension $VmcFileCopyWith on VmcFile {
  /// Returns a callable class that can be used as follows: `instanceOfVmcFile.copyWith(...)` or like so:`instanceOfVmcFile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VmcFileCWProxy get copyWith => _$VmcFileCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `VmcFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VmcFile(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  VmcFile copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool file = false,
  }) {
    return VmcFile(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      file: file == true ? null : this.file,
      json: json,
      mediaId: mediaId,
      vmcFileId: vmcFileId,
      vmcId: vmcId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VmcFile _$VmcFileFromJson(Map<String, dynamic> json) => VmcFile(
      vmcFileId: json['vmcFileId'] as int,
      vmcId: json['vmcId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      file: json['file'] == null
          ? null
          : Media.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VmcFileToJson(VmcFile instance) => <String, dynamic>{
      'vmcFileId': instance.vmcFileId,
      'vmcId': instance.vmcId,
      'mediaId': instance.mediaId,
      'file': instance.file,
      'description': instance.description,
    };
