// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_version_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckVersionResponse _$CheckVersionResponseFromJson(
        Map<String, dynamic> json) =>
    CheckVersionResponse(
      version: json['version'] as int,
      versionString: json['versionString'] as String,
      serverVersion: json['serverVersion'] as int?,
      serverVersionString: json['serverVersionString'] as String?,
      message: json['message'] as String,
      force: json['force'] as bool,
    );

Map<String, dynamic> _$CheckVersionResponseToJson(
        CheckVersionResponse instance) =>
    <String, dynamic>{
      'version': instance.version,
      'versionString': instance.versionString,
      'serverVersion': instance.serverVersion,
      'serverVersionString': instance.serverVersionString,
      'message': instance.message,
      'force': instance.force,
    };
