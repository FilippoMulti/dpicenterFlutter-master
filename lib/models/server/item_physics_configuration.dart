import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'item_physics_configuration.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ItemPhysicsConfiguration extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int itemPhysicsId;

  final double widthMm;
  final double heightMm;
  final double depthMm;

  const ItemPhysicsConfiguration(
      {required this.itemPhysicsId,
      this.widthMm = 50,
      this.heightMm = 50,
      this.depthMm = 10,
      this.json});

  factory ItemPhysicsConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$ItemPhysicsConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ItemPhysicsConfigurationToJson(this);

  static ItemPhysicsConfiguration fromJsonModel(Map<String, dynamic> json) =>
      ItemPhysicsConfiguration.fromJson(json);

  @override
  List<Object?> get props => [
        heightMm,
        itemPhysicsId,
        widthMm,
        depthMm,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
