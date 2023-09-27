import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_category.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ItemCategory extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int itemCategoryId;
  final String code;
  final String description;

  const ItemCategory(
      {required this.itemCategoryId,
      this.code = "",
      this.description = "",
      this.json});

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    var result = _$ItemCategoryFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ItemCategoryToJson(this);

  static ItemCategory fromJsonModel(Map<String, dynamic> json) =>
      ItemCategory.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [itemCategoryId, code, description];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
