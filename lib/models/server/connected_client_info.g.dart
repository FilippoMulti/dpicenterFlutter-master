// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_client_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConnectedClientInfoCWProxy {
  ConnectedClientInfo appVersion(String? appVersion);

  ConnectedClientInfo connectionDate(String? connectionDate);

  ConnectedClientInfo currentDeviceName(String? currentDeviceName);

  ConnectedClientInfo currentOs(String? currentOs);

  ConnectedClientInfo ipAddress(String? ipAddress);

  ConnectedClientInfo json(dynamic json);

  ConnectedClientInfo sessionId(String? sessionId);

  ConnectedClientInfo user(String? user);

  ConnectedClientInfo userAgent(String? userAgent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConnectedClientInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConnectedClientInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  ConnectedClientInfo call({
    String? appVersion,
    String? connectionDate,
    String? currentDeviceName,
    String? currentOs,
    String? ipAddress,
    dynamic? json,
    String? sessionId,
    String? user,
    String? userAgent,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConnectedClientInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConnectedClientInfo.copyWith.fieldName(...)`
class _$ConnectedClientInfoCWProxyImpl implements _$ConnectedClientInfoCWProxy {
  final ConnectedClientInfo _value;

  const _$ConnectedClientInfoCWProxyImpl(this._value);

  @override
  ConnectedClientInfo appVersion(String? appVersion) =>
      this(appVersion: appVersion);

  @override
  ConnectedClientInfo connectionDate(String? connectionDate) =>
      this(connectionDate: connectionDate);

  @override
  ConnectedClientInfo currentDeviceName(String? currentDeviceName) =>
      this(currentDeviceName: currentDeviceName);

  @override
  ConnectedClientInfo currentOs(String? currentOs) =>
      this(currentOs: currentOs);

  @override
  ConnectedClientInfo ipAddress(String? ipAddress) =>
      this(ipAddress: ipAddress);

  @override
  ConnectedClientInfo json(dynamic json) => this(json: json);

  @override
  ConnectedClientInfo sessionId(String? sessionId) =>
      this(sessionId: sessionId);

  @override
  ConnectedClientInfo user(String? user) => this(user: user);

  @override
  ConnectedClientInfo userAgent(String? userAgent) =>
      this(userAgent: userAgent);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConnectedClientInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConnectedClientInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  ConnectedClientInfo call({
    Object? appVersion = const $CopyWithPlaceholder(),
    Object? connectionDate = const $CopyWithPlaceholder(),
    Object? currentDeviceName = const $CopyWithPlaceholder(),
    Object? currentOs = const $CopyWithPlaceholder(),
    Object? ipAddress = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? sessionId = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? userAgent = const $CopyWithPlaceholder(),
  }) {
    return ConnectedClientInfo(
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String?,
      connectionDate: connectionDate == const $CopyWithPlaceholder()
          ? _value.connectionDate
          // ignore: cast_nullable_to_non_nullable
          : connectionDate as String?,
      currentDeviceName: currentDeviceName == const $CopyWithPlaceholder()
          ? _value.currentDeviceName
          // ignore: cast_nullable_to_non_nullable
          : currentDeviceName as String?,
      currentOs: currentOs == const $CopyWithPlaceholder()
          ? _value.currentOs
          // ignore: cast_nullable_to_non_nullable
          : currentOs as String?,
      ipAddress: ipAddress == const $CopyWithPlaceholder()
          ? _value.ipAddress
          // ignore: cast_nullable_to_non_nullable
          : ipAddress as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      sessionId: sessionId == const $CopyWithPlaceholder()
          ? _value.sessionId
          // ignore: cast_nullable_to_non_nullable
          : sessionId as String?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as String?,
      userAgent: userAgent == const $CopyWithPlaceholder()
          ? _value.userAgent
          // ignore: cast_nullable_to_non_nullable
          : userAgent as String?,
    );
  }
}

extension $ConnectedClientInfoCopyWith on ConnectedClientInfo {
  /// Returns a callable class that can be used as follows: `instanceOfConnectedClientInfo.copyWith(...)` or like so:`instanceOfConnectedClientInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConnectedClientInfoCWProxy get copyWith =>
      _$ConnectedClientInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectedClientInfo _$ConnectedClientInfoFromJson(Map<String, dynamic> json) =>
    ConnectedClientInfo(
      user: json['user'] as String?,
      userAgent: json['userAgent'] as String?,
      ipAddress: json['ipAddress'] as String?,
      sessionId: json['sessionId'] as String?,
      appVersion: json['appVersion'] as String?,
      connectionDate: json['connectionDate'] as String?,
      currentOs: json['currentOs'] as String?,
      currentDeviceName: json['currentDeviceName'] as String?,
    );

Map<String, dynamic> _$ConnectedClientInfoToJson(
        ConnectedClientInfo instance) =>
    <String, dynamic>{
      'user': instance.user,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'sessionId': instance.sessionId,
      'appVersion': instance.appVersion,
      'connectionDate': instance.connectionDate,
      'currentOs': instance.currentOs,
      'currentDeviceName': instance.currentDeviceName,
    };
