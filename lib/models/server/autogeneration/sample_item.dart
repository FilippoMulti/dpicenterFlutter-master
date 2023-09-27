import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_category.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sample_item.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class SampleItem extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int sampleItemId;
  final int itemId;
  final Item item;
  final int? itemConfigurationId;
  final SampleItemConfiguration? itemConfiguration;

  final int? sampleItemCategoryId;
  final SampleItemCategory? sampleItemCategory;
  final List<SampleItemPicture>? itemPictures;

  const SampleItem(
      {required this.sampleItemId,
      required this.itemId,
      required this.item,
      this.itemConfigurationId,
      this.itemConfiguration,
      this.sampleItemCategoryId,
      this.sampleItemCategory,
      this.itemPictures,
      this.json});

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    var result = _$SampleItemFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$SampleItemToJson(this);

  static SampleItem fromJsonModel(Map<String, dynamic> json) =>
      SampleItem.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props =>
      [sampleItemId, itemId, itemConfigurationId, sampleItemCategoryId];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
