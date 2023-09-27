// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_setting_file.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MachineSettingFileCWProxy {
  MachineSettingFile compressionId(int? compressionId);

  MachineSettingFile description(String? description);

  MachineSettingFile file(Media? file);

  MachineSettingFile json(dynamic json);

  MachineSettingFile machineSettingFileId(int machineSettingFileId);

  MachineSettingFile machineSettingId(int machineSettingId);

  MachineSettingFile mediaId(int mediaId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineSettingFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineSettingFile(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineSettingFile call({
    int? compressionId,
    String? description,
    Media? file,
    dynamic? json,
    int? machineSettingFileId,
    int? machineSettingId,
    int? mediaId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMachineSettingFile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMachineSettingFile.copyWith.fieldName(...)`
class _$MachineSettingFileCWProxyImpl implements _$MachineSettingFileCWProxy {
  final MachineSettingFile _value;

  const _$MachineSettingFileCWProxyImpl(this._value);

  @override
  MachineSettingFile compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  MachineSettingFile description(String? description) =>
      this(description: description);

  @override
  MachineSettingFile file(Media? file) => this(file: file);

  @override
  MachineSettingFile json(dynamic json) => this(json: json);

  @override
  MachineSettingFile machineSettingFileId(int machineSettingFileId) =>
      this(machineSettingFileId: machineSettingFileId);

  @override
  MachineSettingFile machineSettingId(int machineSettingId) =>
      this(machineSettingId: machineSettingId);

  @override
  MachineSettingFile mediaId(int mediaId) => this(mediaId: mediaId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineSettingFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineSettingFile(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineSettingFile call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? machineSettingFileId = const $CopyWithPlaceholder(),
    Object? machineSettingId = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
  }) {
    return MachineSettingFile(
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
      machineSettingFileId:
          machineSettingFileId == const $CopyWithPlaceholder() ||
                  machineSettingFileId == null
              ? _value.machineSettingFileId
              // ignore: cast_nullable_to_non_nullable
              : machineSettingFileId as int,
      machineSettingId: machineSettingId == const $CopyWithPlaceholder() ||
              machineSettingId == null
          ? _value.machineSettingId
          // ignore: cast_nullable_to_non_nullable
          : machineSettingId as int,
      mediaId: mediaId == const $CopyWithPlaceholder() || mediaId == null
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int,
    );
  }
}

extension $MachineSettingFileCopyWith on MachineSettingFile {
  /// Returns a callable class that can be used as follows: `instanceOfMachineSettingFile.copyWith(...)` or like so:`instanceOfMachineSettingFile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MachineSettingFileCWProxy get copyWith =>
      _$MachineSettingFileCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `MachineSettingFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineSettingFile(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  MachineSettingFile copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool file = false,
  }) {
    return MachineSettingFile(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      file: file == true ? null : this.file,
      json: json,
      machineSettingFileId: machineSettingFileId,
      machineSettingId: machineSettingId,
      mediaId: mediaId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineSettingFile _$MachineSettingFileFromJson(Map<String, dynamic> json) =>
    MachineSettingFile(
      machineSettingFileId: json['machineSettingFileId'] as int,
      machineSettingId: json['machineSettingId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      file: json['file'] == null
          ? null
          : Media.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MachineSettingFileToJson(MachineSettingFile instance) =>
    <String, dynamic>{
      'machineSettingFileId': instance.machineSettingFileId,
      'machineSettingId': instance.machineSettingId,
      'mediaId': instance.mediaId,
      'file': instance.file?.toJson(),
      'description': instance.description,
    };
