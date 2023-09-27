import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'data_frame.g.dart';

@JsonSerializable()
@CopyWith()
class DataFrame extends Equatable implements JsonPayload {
  final int? id;
  final String? question;
  final String? answer;
  final bool generate;
  final int type;
  final String? attachments;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const DataFrame({
    this.id,
    this.question,
    this.answer,
    this.generate = true,
    this.type = 0,
    this.attachments,
    this.json,
  });

  factory DataFrame.fromJson(Map<String, dynamic> json) {
    var result = _$DataFrameFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$DataFrameToJson(this);

  static DataFrame fromJsonModel(Map<String, dynamic> json) =>
      DataFrame.fromJson(json);

  @override
  List<Object?> get props =>
      [
        id,
        question,
        answer,
        generate,
        attachments,
        type,
      ];
}
