import 'package:dpicenter/screen/widgets/signature_multi.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multi_point.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MultiPoint {
  final double dx;
  final double dy;
  final PointType type;

  MultiPoint({required this.dx, required this.dy, required this.type});

  factory MultiPoint.fromJson(Map<String, dynamic> json) {
    var result = _$MultiPointFromJson(json);
    return result;
    //return Manufacturer().decodeJson(json);
  }

  Map<String, dynamic> toJson() => _$MultiPointToJson(this);

  static MultiPoint fromJsonModel(Map<String, dynamic> json) =>
      MultiPoint.fromJson(json);

  @override
  bool operator ==(Object other) =>
      other is MultiPoint &&
      other.dx == dx &&
      other.dy == dy &&
      other.type == type;

  @override
  int get hashCode => "myName".hashCode;
}
