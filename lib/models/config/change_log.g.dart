// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_log.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChangeLogCWProxy {
  ChangeLog date(String? date);

  ChangeLog info(String? info);

  ChangeLog version(String? version);

  ChangeLog versionNumber(int? versionNumber);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChangeLog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChangeLog(...).copyWith(id: 12, name: "My name")
  /// ````
  ChangeLog call({
    String? date,
    String? info,
    String? version,
    int? versionNumber,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChangeLog.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChangeLog.copyWith.fieldName(...)`
class _$ChangeLogCWProxyImpl implements _$ChangeLogCWProxy {
  final ChangeLog _value;

  const _$ChangeLogCWProxyImpl(this._value);

  @override
  ChangeLog date(String? date) => this(date: date);

  @override
  ChangeLog info(String? info) => this(info: info);

  @override
  ChangeLog version(String? version) => this(version: version);

  @override
  ChangeLog versionNumber(int? versionNumber) =>
      this(versionNumber: versionNumber);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChangeLog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChangeLog(...).copyWith(id: 12, name: "My name")
  /// ````
  ChangeLog call({
    Object? date = const $CopyWithPlaceholder(),
    Object? info = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? versionNumber = const $CopyWithPlaceholder(),
  }) {
    return ChangeLog(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String?,
      info: info == const $CopyWithPlaceholder()
          ? _value.info
          // ignore: cast_nullable_to_non_nullable
          : info as String?,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String?,
      versionNumber: versionNumber == const $CopyWithPlaceholder()
          ? _value.versionNumber
          // ignore: cast_nullable_to_non_nullable
          : versionNumber as int?,
    );
  }
}

extension $ChangeLogCopyWith on ChangeLog {
  /// Returns a callable class that can be used as follows: `instanceOfChangeLog.copyWith(...)` or like so:`instanceOfChangeLog.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChangeLogCWProxy get copyWith => _$ChangeLogCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeLog _$ChangeLogFromJson(Map<String, dynamic> json) => ChangeLog(
      date: json['date'] as String?,
      version: json['version'] as String?,
      versionNumber: json['versionNumber'] as int?,
      info: json['info'] as String?,
    );

Map<String, dynamic> _$ChangeLogToJson(ChangeLog instance) => <String, dynamic>{
      'version': instance.version,
      'date': instance.date,
      'versionNumber': instance.versionNumber,
      'info': instance.info,
    };
