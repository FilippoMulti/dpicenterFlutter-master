// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiPoint _$MultiPointFromJson(Map json) => MultiPoint(
      dx: (json['dx'] as num).toDouble(),
      dy: (json['dy'] as num).toDouble(),
      type: $enumDecode(_$PointTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MultiPointToJson(MultiPoint instance) =>
    <String, dynamic>{
      'dx': instance.dx,
      'dy': instance.dy,
      'type': _$PointTypeEnumMap[instance.type]!,
    };

const _$PointTypeEnumMap = {
  PointType.tap: 'tap',
  PointType.move: 'move',
};
