import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/usage_configuration.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vmc_item.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcItem extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;
  final int? color;
  final int itemId;
  final Item item;
  final SampleItemConfiguration? itemConfiguration;
  final UsageConfiguration? usageConfiguration;

  const VmcItem(
      {required this.itemId,
      required this.item,
      this.itemConfiguration,
      this.usageConfiguration,
      this.color,
      this.json});

  factory VmcItem.fromJson(Map<String, dynamic> json) {
    var result = _$VmcItemFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcItemToJson(this);

  static VmcItem fromJsonModel(Map<String, dynamic> json) =>
      VmcItem.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props =>
      [item, itemConfiguration, usageConfiguration, color];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
