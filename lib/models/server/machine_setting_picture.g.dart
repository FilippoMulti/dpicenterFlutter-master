// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_setting_picture.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MachineSettingPictureCWProxy {
  MachineSettingPicture compressionId(int? compressionId);

  MachineSettingPicture description(String? description);

  MachineSettingPicture json(dynamic json);

  MachineSettingPicture machineSettingId(int machineSettingId);

  MachineSettingPicture machineSettingPictureId(int machineSettingPictureId);

  MachineSettingPicture mediaId(int mediaId);

  MachineSettingPicture picture(Media? picture);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineSettingPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineSettingPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineSettingPicture call({
    int? compressionId,
    String? description,
    dynamic? json,
    int? machineSettingId,
    int? machineSettingPictureId,
    int? mediaId,
    Media? picture,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMachineSettingPicture.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMachineSettingPicture.copyWith.fieldName(...)`
class _$MachineSettingPictureCWProxyImpl
    implements _$MachineSettingPictureCWProxy {
  final MachineSettingPicture _value;

  const _$MachineSettingPictureCWProxyImpl(this._value);

  @override
  MachineSettingPicture compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  MachineSettingPicture description(String? description) =>
      this(description: description);

  @override
  MachineSettingPicture json(dynamic json) => this(json: json);

  @override
  MachineSettingPicture machineSettingId(int machineSettingId) =>
      this(machineSettingId: machineSettingId);

  @override
  MachineSettingPicture machineSettingPictureId(int machineSettingPictureId) =>
      this(machineSettingPictureId: machineSettingPictureId);

  @override
  MachineSettingPicture mediaId(int mediaId) => this(mediaId: mediaId);

  @override
  MachineSettingPicture picture(Media? picture) => this(picture: picture);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineSettingPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineSettingPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineSettingPicture call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? machineSettingId = const $CopyWithPlaceholder(),
    Object? machineSettingPictureId = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? picture = const $CopyWithPlaceholder(),
  }) {
    return MachineSettingPicture(
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
      machineSettingId: machineSettingId == const $CopyWithPlaceholder() ||
              machineSettingId == null
          ? _value.machineSettingId
          // ignore: cast_nullable_to_non_nullable
          : machineSettingId as int,
      machineSettingPictureId:
          machineSettingPictureId == const $CopyWithPlaceholder() ||
                  machineSettingPictureId == null
              ? _value.machineSettingPictureId
              // ignore: cast_nullable_to_non_nullable
              : machineSettingPictureId as int,
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

extension $MachineSettingPictureCopyWith on MachineSettingPicture {
  /// Returns a callable class that can be used as follows: `instanceOfMachineSettingPicture.copyWith(...)` or like so:`instanceOfMachineSettingPicture.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MachineSettingPictureCWProxy get copyWith =>
      _$MachineSettingPictureCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `MachineSettingPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineSettingPicture(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  MachineSettingPicture copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool picture = false,
  }) {
    return MachineSettingPicture(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      json: json,
      machineSettingId: machineSettingId,
      machineSettingPictureId: machineSettingPictureId,
      mediaId: mediaId,
      picture: picture == true ? null : this.picture,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineSettingPicture _$MachineSettingPictureFromJson(
        Map<String, dynamic> json) =>
    MachineSettingPicture(
      machineSettingPictureId: json['machineSettingPictureId'] as int,
      machineSettingId: json['machineSettingId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      picture: json['picture'] == null
          ? null
          : Media.fromJson(json['picture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MachineSettingPictureToJson(
        MachineSettingPicture instance) =>
    <String, dynamic>{
      'machineSettingPictureId': instance.machineSettingPictureId,
      'machineSettingId': instance.machineSettingId,
      'mediaId': instance.mediaId,
      'picture': instance.picture?.toJson(),
      'description': instance.description,
    };
