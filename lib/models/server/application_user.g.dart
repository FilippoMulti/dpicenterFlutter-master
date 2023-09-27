// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationUserCWProxy {
  ApplicationUser applicationProfileId(int? applicationProfileId);

  ApplicationUser applicationUserId(int? applicationUserId);

  ApplicationUser json(dynamic json);

  ApplicationUser name(String? name);

  ApplicationUser password(String? password);

  ApplicationUser profile(ApplicationProfile? profile);

  ApplicationUser refreshToken(String? refreshToken);

  ApplicationUser surname(String? surname);

  ApplicationUser theme(String? theme);

  ApplicationUser userDetails(List<ApplicationUserDetail>? userDetails);

  ApplicationUser userName(String? userName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationUser(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationUser call({
    int? applicationProfileId,
    int? applicationUserId,
    dynamic? json,
    String? name,
    String? password,
    ApplicationProfile? profile,
    String? refreshToken,
    String? surname,
    String? theme,
    List<ApplicationUserDetail>? userDetails,
    String? userName,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationUser.copyWith.fieldName(...)`
class _$ApplicationUserCWProxyImpl implements _$ApplicationUserCWProxy {
  final ApplicationUser _value;

  const _$ApplicationUserCWProxyImpl(this._value);

  @override
  ApplicationUser applicationProfileId(int? applicationProfileId) =>
      this(applicationProfileId: applicationProfileId);

  @override
  ApplicationUser applicationUserId(int? applicationUserId) =>
      this(applicationUserId: applicationUserId);

  @override
  ApplicationUser json(dynamic json) => this(json: json);

  @override
  ApplicationUser name(String? name) => this(name: name);

  @override
  ApplicationUser password(String? password) => this(password: password);

  @override
  ApplicationUser profile(ApplicationProfile? profile) =>
      this(profile: profile);

  @override
  ApplicationUser refreshToken(String? refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  ApplicationUser surname(String? surname) => this(surname: surname);

  @override
  ApplicationUser theme(String? theme) => this(theme: theme);

  @override
  ApplicationUser userDetails(List<ApplicationUserDetail>? userDetails) =>
      this(userDetails: userDetails);

  @override
  ApplicationUser userName(String? userName) => this(userName: userName);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationUser(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationUser call({
    Object? applicationProfileId = const $CopyWithPlaceholder(),
    Object? applicationUserId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
    Object? profile = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? surname = const $CopyWithPlaceholder(),
    Object? theme = const $CopyWithPlaceholder(),
    Object? userDetails = const $CopyWithPlaceholder(),
    Object? userName = const $CopyWithPlaceholder(),
  }) {
    return ApplicationUser(
      applicationProfileId: applicationProfileId == const $CopyWithPlaceholder()
          ? _value.applicationProfileId
          // ignore: cast_nullable_to_non_nullable
          : applicationProfileId as int?,
      applicationUserId: applicationUserId == const $CopyWithPlaceholder()
          ? _value.applicationUserId
          // ignore: cast_nullable_to_non_nullable
          : applicationUserId as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String?,
      profile: profile == const $CopyWithPlaceholder()
          ? _value.profile
          // ignore: cast_nullable_to_non_nullable
          : profile as ApplicationProfile?,
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String?,
      surname: surname == const $CopyWithPlaceholder()
          ? _value.surname
          // ignore: cast_nullable_to_non_nullable
          : surname as String?,
      theme: theme == const $CopyWithPlaceholder()
          ? _value.theme
          // ignore: cast_nullable_to_non_nullable
          : theme as String?,
      userDetails: userDetails == const $CopyWithPlaceholder()
          ? _value.userDetails
          // ignore: cast_nullable_to_non_nullable
          : userDetails as List<ApplicationUserDetail>?,
      userName: userName == const $CopyWithPlaceholder()
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String?,
    );
  }
}

extension $ApplicationUserCopyWith on ApplicationUser {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationUser.copyWith(...)` or like so:`instanceOfApplicationUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationUserCWProxy get copyWith => _$ApplicationUserCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ApplicationUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationUser(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ApplicationUser copyWithNull({
    bool applicationProfileId = false,
    bool applicationUserId = false,
    bool name = false,
    bool password = false,
    bool profile = false,
    bool refreshToken = false,
    bool surname = false,
    bool theme = false,
    bool userDetails = false,
    bool userName = false,
  }) {
    return ApplicationUser(
      applicationProfileId:
          applicationProfileId == true ? null : this.applicationProfileId,
      applicationUserId:
          applicationUserId == true ? null : this.applicationUserId,
      json: json,
      name: name == true ? null : this.name,
      password: password == true ? null : this.password,
      profile: profile == true ? null : this.profile,
      refreshToken: refreshToken == true ? null : this.refreshToken,
      surname: surname == true ? null : this.surname,
      theme: theme == true ? null : this.theme,
      userDetails: userDetails == true ? null : this.userDetails,
      userName: userName == true ? null : this.userName,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationUser _$ApplicationUserFromJson(Map<String, dynamic> json) =>
    ApplicationUser(
      applicationUserId: json['applicationUserId'] as int?,
      userName: json['userName'] as String?,
      password: json['password'] as String?,
      theme: json['theme'] as String?,
      applicationProfileId: json['applicationProfileId'] as int?,
      profile: json['profile'] == null
          ? null
          : ApplicationProfile.fromJson(
              json['profile'] as Map<String, dynamic>),
      refreshToken: json['refreshToken'] as String?,
      surname: json['surname'] as String?,
      name: json['name'] as String?,
      userDetails: (json['userDetails'] as List<dynamic>?)
          ?.map(
              (e) => ApplicationUserDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApplicationUserToJson(ApplicationUser instance) =>
    <String, dynamic>{
      'applicationUserId': instance.applicationUserId,
      'userName': instance.userName,
      'surname': instance.surname,
      'name': instance.name,
      'password': instance.password,
      'theme': instance.theme,
      'applicationProfileId': instance.applicationProfileId,
      'profile': instance.profile,
      'refreshToken': instance.refreshToken,
      'userDetails': instance.userDetails,
    };
