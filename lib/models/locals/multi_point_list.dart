import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dpicenter/screen/widgets/signature_multi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'multi_point.dart';

part 'multi_point_list.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MultiPointList {
  @JsonKey(ignore: true)
  final String _name = "MultiPointList";

  List<MultiPoint> points;

  MultiPointList({required this.points});

  factory MultiPointList.fromJson(Map<String, dynamic> json) {
    var result = _$MultiPointListFromJson(json);
    return result;
    //return Manufacturer().decodeJson(json);
  }

  factory MultiPointList.fromPoints(List<Point> points) {
    List<MultiPoint> multiPoints = points
        .map((e) => MultiPoint(dx: e.offset.dx, dy: e.offset.dy, type: e.type))
        .toList();
    return MultiPointList(points: multiPoints);
  }

  factory MultiPointList.fromZippedString(String zippedString) {
    var zipBytes = base64Decode(zippedString);
    List<int> codeMetrics = GZipDecoder().decodeBytes(zipBytes);
    Uint8List bytes = Uint8List.fromList(codeMetrics);
    String json = String.fromCharCodes(bytes);
    var decodedJson = jsonDecode(json);
    return MultiPointList.fromJson(decodedJson);
  }

  Map<String, dynamic> toJson() => _$MultiPointListToJson(this);

  List<Point> toPoints() =>
      points.map((e) => Point(Offset(e.dx, e.dy), e.type)).toList();

  String toZippedString() {
    try {
      List<int> list = json.encode(toJson()).codeUnits;
      var gzipBytes = GZipEncoder().encode(list);
      return base64Encode(gzipBytes!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return "";
  }

  static MultiPointList fromJsonModel(Map<String, dynamic> json) =>
      MultiPointList.fromJson(json);

  @override
  bool operator ==(Object other) =>
      other is MultiPointList && other._name == _name && other.points == points;

  @override
  int get hashCode => _name.hashCode;
}
