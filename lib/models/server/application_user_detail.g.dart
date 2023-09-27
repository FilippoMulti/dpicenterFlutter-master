// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_user_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationUserDetailCWProxy {
  ApplicationUserDetail applicationUserDetailId(int? applicationUserDetailId);

  ApplicationUserDetail applicationUserId(int? applicationUserId);

  ApplicationUserDetail image(String? image);

  ApplicationUserDetail imageProvider(ImageProvider<Object>? imageProvider);

  ApplicationUserDetail json(dynamic json);

  ApplicationUserDetail thumbImage(String? thumbImage);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationUserDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationUserDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationUserDetail call({
    int? applicationUserDetailId,
    int? applicationUserId,
    String? image,
    ImageProvider<Object>? imageProvider,
    dynamic? json,
    String? thumbImage,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationUserDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationUserDetail.copyWith.fieldName(...)`
class _$ApplicationUserDetailCWProxyImpl
    implements _$ApplicationUserDetailCWProxy {
  final ApplicationUserDetail _value;

  const _$ApplicationUserDetailCWProxyImpl(this._value);

  @override
  ApplicationUserDetail applicationUserDetailId(int? applicationUserDetailId) =>
      this(applicationUserDetailId: applicationUserDetailId);

  @override
  ApplicationUserDetail applicationUserId(int? applicationUserId) =>
      this(applicationUserId: applicationUserId);

  @override
  ApplicationUserDetail image(String? image) => this(image: image);

  @override
  ApplicationUserDetail imageProvider(ImageProvider<Object>? imageProvider) =>
      this(imageProvider: imageProvider);

  @override
  ApplicationUserDetail json(dynamic json) => this(json: json);

  @override
  ApplicationUserDetail thumbImage(String? thumbImage) =>
      this(thumbImage: thumbImage);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationUserDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationUserDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationUserDetail call({
    Object? applicationUserDetailId = const $CopyWithPlaceholder(),
    Object? applicationUserId = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? imageProvider = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? thumbImage = const $CopyWithPlaceholder(),
  }) {
    return ApplicationUserDetail(
      applicationUserDetailId:
          applicationUserDetailId == const $CopyWithPlaceholder()
              ? _value.applicationUserDetailId
              // ignore: cast_nullable_to_non_nullable
              : applicationUserDetailId as int?,
      applicationUserId: applicationUserId == const $CopyWithPlaceholder()
          ? _value.applicationUserId
          // ignore: cast_nullable_to_non_nullable
          : applicationUserId as int?,
      image: image == const $CopyWithPlaceholder()
          ? _value.image
          // ignore: cast_nullable_to_non_nullable
          : image as String?,
      imageProvider: imageProvider == const $CopyWithPlaceholder()
          ? _value.imageProvider
          // ignore: cast_nullable_to_non_nullable
          : imageProvider as ImageProvider<Object>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      thumbImage: thumbImage == const $CopyWithPlaceholder()
          ? _value.thumbImage
          // ignore: cast_nullable_to_non_nullable
          : thumbImage as String?,
    );
  }
}

extension $ApplicationUserDetailCopyWith on ApplicationUserDetail {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationUserDetail.copyWith(...)` or like so:`instanceOfApplicationUserDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationUserDetailCWProxy get copyWith =>
      _$ApplicationUserDetailCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ApplicationUserDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationUserDetail(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ApplicationUserDetail copyWithNull({
    bool applicationUserDetailId = false,
    bool applicationUserId = false,
    bool image = false,
    bool imageProvider = false,
    bool thumbImage = false,
  }) {
    return ApplicationUserDetail(
      applicationUserDetailId:
          applicationUserDetailId == true ? null : this.applicationUserDetailId,
      applicationUserId:
          applicationUserId == true ? null : this.applicationUserId,
      image: image == true ? null : this.image,
      imageProvider: imageProvider == true ? null : this.imageProvider,
      json: json,
      thumbImage: thumbImage == true ? null : this.thumbImage,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationUserDetail _$ApplicationUserDetailFromJson(
        Map<String, dynamic> json) =>
    ApplicationUserDetail(
      applicationUserDetailId: json['applicationUserDetailId'] as int?,
      applicationUserId: json['applicationUserId'] as int?,
      image: json['image'] as String?,
      thumbImage: json['thumbImage'] as String?,
    );

Map<String, dynamic> _$ApplicationUserDetailToJson(
        ApplicationUserDetail instance) =>
    <String, dynamic>{
      'applicationUserDetailId': instance.applicationUserDetailId,
      'applicationUserId': instance.applicationUserId,
      'image': instance.image,
      'thumbImage': instance.thumbImage,
    };
