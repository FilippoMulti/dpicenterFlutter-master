// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_config_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartConfigCWProxy {
  StartConfig changeLogs(List<ChangeLog>? changeLogs);

  StartConfig connectionTimeout(int? connectionTimeout);

  StartConfig currentVersion(int? currentVersion);

  StartConfig currentVersionString(String? currentVersionString);

  StartConfig requestCloseTimeout(int? requestCloseTimeout);

  StartConfig url(String? url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  StartConfig call({
    List<ChangeLog>? changeLogs,
    int? connectionTimeout,
    int? currentVersion,
    String? currentVersionString,
    int? requestCloseTimeout,
    String? url,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStartConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStartConfig.copyWith.fieldName(...)`
class _$StartConfigCWProxyImpl implements _$StartConfigCWProxy {
  final StartConfig _value;

  const _$StartConfigCWProxyImpl(this._value);

  @override
  StartConfig changeLogs(List<ChangeLog>? changeLogs) =>
      this(changeLogs: changeLogs);

  @override
  StartConfig connectionTimeout(int? connectionTimeout) =>
      this(connectionTimeout: connectionTimeout);

  @override
  StartConfig currentVersion(int? currentVersion) =>
      this(currentVersion: currentVersion);

  @override
  StartConfig currentVersionString(String? currentVersionString) =>
      this(currentVersionString: currentVersionString);

  @override
  StartConfig requestCloseTimeout(int? requestCloseTimeout) =>
      this(requestCloseTimeout: requestCloseTimeout);

  @override
  StartConfig url(String? url) => this(url: url);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  StartConfig call({
    Object? changeLogs = const $CopyWithPlaceholder(),
    Object? connectionTimeout = const $CopyWithPlaceholder(),
    Object? currentVersion = const $CopyWithPlaceholder(),
    Object? currentVersionString = const $CopyWithPlaceholder(),
    Object? requestCloseTimeout = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return StartConfig(
      changeLogs: changeLogs == const $CopyWithPlaceholder()
          ? _value.changeLogs
          // ignore: cast_nullable_to_non_nullable
          : changeLogs as List<ChangeLog>?,
      connectionTimeout: connectionTimeout == const $CopyWithPlaceholder()
          ? _value.connectionTimeout
          // ignore: cast_nullable_to_non_nullable
          : connectionTimeout as int?,
      currentVersion: currentVersion == const $CopyWithPlaceholder()
          ? _value.currentVersion
          // ignore: cast_nullable_to_non_nullable
          : currentVersion as int?,
      currentVersionString: currentVersionString == const $CopyWithPlaceholder()
          ? _value.currentVersionString
          // ignore: cast_nullable_to_non_nullable
          : currentVersionString as String?,
      requestCloseTimeout: requestCloseTimeout == const $CopyWithPlaceholder()
          ? _value.requestCloseTimeout
          // ignore: cast_nullable_to_non_nullable
          : requestCloseTimeout as int?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $StartConfigCopyWith on StartConfig {
  /// Returns a callable class that can be used as follows: `instanceOfStartConfig.copyWith(...)` or like so:`instanceOfStartConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartConfigCWProxy get copyWith => _$StartConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartConfig _$StartConfigFromJson(Map<String, dynamic> json) => StartConfig(
      url: json['url'] as String?,
      currentVersion: json['currentVersion'] as int?,
      currentVersionString: json['currentVersionString'] as String?,
      connectionTimeout: json['connectionTimeout'] as int?,
      requestCloseTimeout: json['requestCloseTimeout'] as int?,
      changeLogs: (json['changeLogs'] as List<dynamic>?)
          ?.map((e) => ChangeLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StartConfigToJson(StartConfig instance) =>
    <String, dynamic>{
      'url': instance.url,
      'currentVersionString': instance.currentVersionString,
      'currentVersion': instance.currentVersion,
      'connectionTimeout': instance.connectionTimeout,
      'requestCloseTimeout': instance.requestCloseTimeout,
      'changeLogs': instance.changeLogs,
    };
