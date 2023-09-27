import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vitality/models/ItemBehaviour.dart';

part 'background_shape.g.dart';

@JsonSerializable()
@CopyWith()
class BackgroundShape implements Equatable {
  final ShapeType shape;
  final String? icon;

  const BackgroundShape({this.shape = ShapeType.FilledCircle, this.icon});

  factory BackgroundShape.fromJson(Map<String, dynamic> json) {
    var result = _$BackgroundShapeFromJson(json);
    return result;
  }

  Map<String, dynamic> toJson() => _$BackgroundShapeToJson(this);

  static BackgroundShape fromJsonModel(Map<String, dynamic> json) =>
      BackgroundShape.fromJson(json);

  ItemBehaviour toItemBehaviour() {
    return ItemBehaviour(shape: shape, icon: icon != null ? icons[icon] : null);
  }

  @override
  List<Object?> get props => [shape, icon];

  @override
  bool? get stringify => true;
}
