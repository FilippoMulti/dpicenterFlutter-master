import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sample_item_category.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class SampleItemCategory extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int sampleItemCategoryId;
  final String code;
  final String description;

  const SampleItemCategory(
      {required this.sampleItemCategoryId,
      this.code = "",
      this.description = "",
      this.json});

  factory SampleItemCategory.fromJson(Map<String, dynamic> json) {
    var result = _$SampleItemCategoryFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$SampleItemCategoryToJson(this);

  static SampleItemCategory fromJsonModel(Map<String, dynamic> json) =>
      SampleItemCategory.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [sampleItemCategoryId, code, description];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
