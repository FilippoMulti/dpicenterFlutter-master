// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_point_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiPointList _$MultiPointListFromJson(Map json) => MultiPointList(
      points: (json['points'] as List<dynamic>)
          .map((e) => MultiPoint.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$MultiPointListToJson(MultiPointList instance) =>
    <String, dynamic>{
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
