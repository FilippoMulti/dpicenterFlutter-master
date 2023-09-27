import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/item_category.dart';
import 'package:dpicenter/models/server/item_physics_configuration.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class Item extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int itemId;
  final String? code;
  final String? description;
  final String? barcode;

  final int? itemPhysicsId;
  final ItemPhysicsConfiguration? physicsConfiguration;

  final List<ItemPicture>? itemPictures;

  final int? itemCategoryId;
  final ItemCategory? itemCategory;

  const Item(
      {required this.itemId,
      this.code,
      this.description,
      this.barcode,
      this.itemPictures,
      this.physicsConfiguration,
      this.itemPhysicsId,
      this.itemCategory,
      this.itemCategoryId,
      this.json});

  factory Item.fromJson(Map<String, dynamic> json) {
    var result = _$ItemFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  static Item fromJsonModel(Map<String, dynamic> json) => Item.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [code, description, barcode, itemPhysicsId];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
