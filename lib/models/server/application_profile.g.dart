// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_profile.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationProfileCWProxy {
  ApplicationProfile applicationProfileId(int? applicationProfileId);

  ApplicationProfile enabledMenus(
      List<ApplicationProfileEnabledMenu>? enabledMenus);

  ApplicationProfile json(dynamic json);

  ApplicationProfile profileName(String? profileName);

  ApplicationProfile specialType(int? specialType);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationProfile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationProfile call({
    int? applicationProfileId,
    List<ApplicationProfileEnabledMenu>? enabledMenus,
    dynamic? json,
    String? profileName,
    int? specialType,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationProfile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationProfile.copyWith.fieldName(...)`
class _$ApplicationProfileCWProxyImpl implements _$ApplicationProfileCWProxy {
  final ApplicationProfile _value;

  const _$ApplicationProfileCWProxyImpl(this._value);

  @override
  ApplicationProfile applicationProfileId(int? applicationProfileId) =>
      this(applicationProfileId: applicationProfileId);

  @override
  ApplicationProfile enabledMenus(
          List<ApplicationProfileEnabledMenu>? enabledMenus) =>
      this(enabledMenus: enabledMenus);

  @override
  ApplicationProfile json(dynamic json) => this(json: json);

  @override
  ApplicationProfile profileName(String? profileName) =>
      this(profileName: profileName);

  @override
  ApplicationProfile specialType(int? specialType) =>
      this(specialType: specialType);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationProfile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationProfile call({
    Object? applicationProfileId = const $CopyWithPlaceholder(),
    Object? enabledMenus = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? profileName = const $CopyWithPlaceholder(),
    Object? specialType = const $CopyWithPlaceholder(),
  }) {
    return ApplicationProfile(
      applicationProfileId: applicationProfileId == const $CopyWithPlaceholder()
          ? _value.applicationProfileId
          // ignore: cast_nullable_to_non_nullable
          : applicationProfileId as int?,
      enabledMenus: enabledMenus == const $CopyWithPlaceholder()
          ? _value.enabledMenus
          // ignore: cast_nullable_to_non_nullable
          : enabledMenus as List<ApplicationProfileEnabledMenu>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      profileName: profileName == const $CopyWithPlaceholder()
          ? _value.profileName
          // ignore: cast_nullable_to_non_nullable
          : profileName as String?,
      specialType: specialType == const $CopyWithPlaceholder()
          ? _value.specialType
          // ignore: cast_nullable_to_non_nullable
          : specialType as int?,
    );
  }
}

extension $ApplicationProfileCopyWith on ApplicationProfile {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationProfile.copyWith(...)` or like so:`instanceOfApplicationProfile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationProfileCWProxy get copyWith =>
      _$ApplicationProfileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationProfile _$ApplicationProfileFromJson(Map<String, dynamic> json) =>
    ApplicationProfile(
      applicationProfileId: json['applicationProfileId'] as int?,
      profileName: json['profileName'] as String?,
      specialType: json['specialType'] as int?,
      enabledMenus: (json['enabledMenus'] as List<dynamic>?)
          ?.map((e) =>
              ApplicationProfileEnabledMenu.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApplicationProfileToJson(ApplicationProfile instance) =>
    <String, dynamic>{
      'applicationProfileId': instance.applicationProfileId,
      'profileName': instance.profileName,
      'specialType': instance.specialType,
      'enabledMenus': instance.enabledMenus,
    };
