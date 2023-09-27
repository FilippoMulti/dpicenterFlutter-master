import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'space.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class Space extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int id;
  final double? position;
  final VmcItem? item;
  final int tickInSingleSpace;

  set item(VmcItem? itemToSet) {
    item = itemToSet;
  }

  //final VmcRow? row;
  final bool visible;
  final int rowIndex;

  final bool removed;
  final double? widthSpaces;

  bool get isEmpty => item == null;

  bool get isNotEmpty => item != null;

  double get currentWidthSpaces =>
      item?.itemConfiguration?.widthSpaces ?? widthSpaces ?? 0;

  double get currentOccupiedWidthSpaces =>
      item?.itemConfiguration?.widthSpaces ?? 0;

  const Space(
      {required this.id,
      this.position,
      this.item,
      //this.row,
      this.json,
      this.widthSpaces,
      this.visible = true,
      this.removed = false,
      this.tickInSingleSpace = 4,
      required this.rowIndex});

  factory Space.fromJson(Map<String, dynamic> json) {
    var result = _$SpaceFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$SpaceToJson(this);

  static Space fromJsonModel(Map<String, dynamic> json) => Space.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props =>
      [position, item, id, widthSpaces, visible, rowIndex];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
