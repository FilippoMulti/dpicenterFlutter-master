// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_version.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServerVersionCWProxy {
  ServerVersion currentVersion(String currentVersion);

  ServerVersion json(dynamic json);

  ServerVersion versionNumber(int versionNumber);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServerVersion(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServerVersion(...).copyWith(id: 12, name: "My name")
  /// ````
  ServerVersion call({
    String? currentVersion,
    dynamic? json,
    int? versionNumber,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServerVersion.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServerVersion.copyWith.fieldName(...)`
class _$ServerVersionCWProxyImpl implements _$ServerVersionCWProxy {
  final ServerVersion _value;

  const _$ServerVersionCWProxyImpl(this._value);

  @override
  ServerVersion currentVersion(String currentVersion) =>
      this(currentVersion: currentVersion);

  @override
  ServerVersion json(dynamic json) => this(json: json);

  @override
  ServerVersion versionNumber(int versionNumber) =>
      this(versionNumber: versionNumber);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServerVersion(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServerVersion(...).copyWith(id: 12, name: "My name")
  /// ````
  ServerVersion call({
    Object? currentVersion = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? versionNumber = const $CopyWithPlaceholder(),
  }) {
    return ServerVersion(
      currentVersion: currentVersion == const $CopyWithPlaceholder() ||
              currentVersion == null
          ? _value.currentVersion
          // ignore: cast_nullable_to_non_nullable
          : currentVersion as String,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      versionNumber:
          versionNumber == const $CopyWithPlaceholder() || versionNumber == null
              ? _value.versionNumber
              // ignore: cast_nullable_to_non_nullable
              : versionNumber as int,
    );
  }
}

extension $ServerVersionCopyWith on ServerVersion {
  /// Returns a callable class that can be used as follows: `instanceOfServerVersion.copyWith(...)` or like so:`instanceOfServerVersion.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServerVersionCWProxy get copyWith => _$ServerVersionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerVersion _$ServerVersionFromJson(Map<String, dynamic> json) =>
    ServerVersion(
      versionNumber: json['versionNumber'] as int,
      currentVersion: json['currentVersion'] as String,
    );

Map<String, dynamic> _$ServerVersionToJson(ServerVersion instance) =>
    <String, dynamic>{
      'versionNumber': instance.versionNumber,
      'currentVersion': instance.currentVersion,
    };
