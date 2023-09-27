// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_production_file.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MachineProductionFileCWProxy {
  MachineProductionFile compressionId(int? compressionId);

  MachineProductionFile description(String? description);

  MachineProductionFile file(Media? file);

  MachineProductionFile json(dynamic json);

  MachineProductionFile machineProductionFileId(int machineProductionFileId);

  MachineProductionFile machineProductionId(int machineProductionId);

  MachineProductionFile mediaId(int mediaId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineProductionFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineProductionFile(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineProductionFile call({
    int? compressionId,
    String? description,
    Media? file,
    dynamic? json,
    int? machineProductionFileId,
    int? machineProductionId,
    int? mediaId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMachineProductionFile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMachineProductionFile.copyWith.fieldName(...)`
class _$MachineProductionFileCWProxyImpl
    implements _$MachineProductionFileCWProxy {
  final MachineProductionFile _value;

  const _$MachineProductionFileCWProxyImpl(this._value);

  @override
  MachineProductionFile compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  MachineProductionFile description(String? description) =>
      this(description: description);

  @override
  MachineProductionFile file(Media? file) => this(file: file);

  @override
  MachineProductionFile json(dynamic json) => this(json: json);

  @override
  MachineProductionFile machineProductionFileId(int machineProductionFileId) =>
      this(machineProductionFileId: machineProductionFileId);

  @override
  MachineProductionFile machineProductionId(int machineProductionId) =>
      this(machineProductionId: machineProductionId);

  @override
  MachineProductionFile mediaId(int mediaId) => this(mediaId: mediaId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineProductionFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineProductionFile(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineProductionFile call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? machineProductionFileId = const $CopyWithPlaceholder(),
    Object? machineProductionId = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
  }) {
    return MachineProductionFile(
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
      machineProductionFileId:
          machineProductionFileId == const $CopyWithPlaceholder() ||
                  machineProductionFileId == null
              ? _value.machineProductionFileId
              // ignore: cast_nullable_to_non_nullable
              : machineProductionFileId as int,
      machineProductionId:
          machineProductionId == const $CopyWithPlaceholder() ||
                  machineProductionId == null
              ? _value.machineProductionId
              // ignore: cast_nullable_to_non_nullable
              : machineProductionId as int,
      mediaId: mediaId == const $CopyWithPlaceholder() || mediaId == null
          ? _value.mediaId
          // ignore: cast_nullable_to_non_nullable
          : mediaId as int,
    );
  }
}

extension $MachineProductionFileCopyWith on MachineProductionFile {
  /// Returns a callable class that can be used as follows: `instanceOfMachineProductionFile.copyWith(...)` or like so:`instanceOfMachineProductionFile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MachineProductionFileCWProxy get copyWith =>
      _$MachineProductionFileCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `MachineProductionFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineProductionFile(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  MachineProductionFile copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool file = false,
  }) {
    return MachineProductionFile(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      file: file == true ? null : this.file,
      json: json,
      machineProductionFileId: machineProductionFileId,
      machineProductionId: machineProductionId,
      mediaId: mediaId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineProductionFile _$MachineProductionFileFromJson(
        Map<String, dynamic> json) =>
    MachineProductionFile(
      machineProductionFileId: json['machineProductionFileId'] as int,
      machineProductionId: json['machineProductionId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      file: json['file'] == null
          ? null
          : Media.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MachineProductionFileToJson(
        MachineProductionFile instance) =>
    <String, dynamic>{
      'machineProductionFileId': instance.machineProductionFileId,
      'machineProductionId': instance.machineProductionId,
      'mediaId': instance.mediaId,
      'file': instance.file?.toJson(),
      'description': instance.description,
    };
