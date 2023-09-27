// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintResponse _$PrintResponseFromJson(Map<String, dynamic> json) =>
    PrintResponse(
      json['status'] as int?,
      json['resultFile'] as String?,
    );

Map<String, dynamic> _$PrintResponseToJson(PrintResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'resultFile': instance.resultFile,
    };
