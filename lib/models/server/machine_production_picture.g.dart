// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_production_picture.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MachineProductionPictureCWProxy {
  MachineProductionPicture compressionId(int? compressionId);

  MachineProductionPicture description(String? description);

  MachineProductionPicture json(dynamic json);

  MachineProductionPicture machineProductionId(int machineProductionId);

  MachineProductionPicture machineProductionPictureId(
      int machineProductionPictureId);

  MachineProductionPicture mediaId(int mediaId);

  MachineProductionPicture picture(Media? picture);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineProductionPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineProductionPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineProductionPicture call({
    int? compressionId,
    String? description,
    dynamic? json,
    int? machineProductionId,
    int? machineProductionPictureId,
    int? mediaId,
    Media? picture,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMachineProductionPicture.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMachineProductionPicture.copyWith.fieldName(...)`
class _$MachineProductionPictureCWProxyImpl
    implements _$MachineProductionPictureCWProxy {
  final MachineProductionPicture _value;

  const _$MachineProductionPictureCWProxyImpl(this._value);

  @override
  MachineProductionPicture compressionId(int? compressionId) =>
      this(compressionId: compressionId);

  @override
  MachineProductionPicture description(String? description) =>
      this(description: description);

  @override
  MachineProductionPicture json(dynamic json) => this(json: json);

  @override
  MachineProductionPicture machineProductionId(int machineProductionId) =>
      this(machineProductionId: machineProductionId);

  @override
  MachineProductionPicture machineProductionPictureId(
          int machineProductionPictureId) =>
      this(machineProductionPictureId: machineProductionPictureId);

  @override
  MachineProductionPicture mediaId(int mediaId) => this(mediaId: mediaId);

  @override
  MachineProductionPicture picture(Media? picture) => this(picture: picture);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineProductionPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineProductionPicture(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineProductionPicture call({
    Object? compressionId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? machineProductionId = const $CopyWithPlaceholder(),
    Object? machineProductionPictureId = const $CopyWithPlaceholder(),
    Object? mediaId = const $CopyWithPlaceholder(),
    Object? picture = const $CopyWithPlaceholder(),
  }) {
    return MachineProductionPicture(
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
      machineProductionId:
          machineProductionId == const $CopyWithPlaceholder() ||
                  machineProductionId == null
              ? _value.machineProductionId
              // ignore: cast_nullable_to_non_nullable
              : machineProductionId as int,
      machineProductionPictureId:
          machineProductionPictureId == const $CopyWithPlaceholder() ||
                  machineProductionPictureId == null
              ? _value.machineProductionPictureId
              // ignore: cast_nullable_to_non_nullable
              : machineProductionPictureId as int,
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

extension $MachineProductionPictureCopyWith on MachineProductionPicture {
  /// Returns a callable class that can be used as follows: `instanceOfMachineProductionPicture.copyWith(...)` or like so:`instanceOfMachineProductionPicture.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MachineProductionPictureCWProxy get copyWith =>
      _$MachineProductionPictureCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `MachineProductionPicture(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineProductionPicture(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  MachineProductionPicture copyWithNull({
    bool compressionId = false,
    bool description = false,
    bool picture = false,
  }) {
    return MachineProductionPicture(
      compressionId: compressionId == true ? null : this.compressionId,
      description: description == true ? null : this.description,
      json: json,
      machineProductionId: machineProductionId,
      machineProductionPictureId: machineProductionPictureId,
      mediaId: mediaId,
      picture: picture == true ? null : this.picture,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineProductionPicture _$MachineProductionPictureFromJson(
        Map<String, dynamic> json) =>
    MachineProductionPicture(
      machineProductionPictureId: json['machineProductionPictureId'] as int,
      machineProductionId: json['machineProductionId'] as int,
      mediaId: json['mediaId'] as int,
      description: json['description'] as String?,
      picture: json['picture'] == null
          ? null
          : Media.fromJson(json['picture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MachineProductionPictureToJson(
        MachineProductionPicture instance) =>
    <String, dynamic>{
      'machineProductionPictureId': instance.machineProductionPictureId,
      'machineProductionId': instance.machineProductionId,
      'mediaId': instance.mediaId,
      'picture': instance.picture?.toJson(),
      'description': instance.description,
    };
