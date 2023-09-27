import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/dalle/link.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'response_model.g.dart';

@JsonSerializable()
@CopyWith()
class ResponseModel extends Equatable implements JsonPayload {
  final int? created;
  final List<Link>? data;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ResponseModel({
    this.created,
    this.data,
    this.json,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    var result = _$ResponseModelFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);

  static ResponseModel fromJsonModel(Map<String, dynamic> json) =>
      ResponseModel.fromJson(json);

  @override
  List<Object?> get props => [created, data];
}
