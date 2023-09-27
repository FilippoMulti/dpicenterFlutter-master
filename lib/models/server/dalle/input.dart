import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'input.g.dart';

@JsonSerializable()
@CopyWith()
class Input extends Equatable implements JsonPayload {
  final String? prompt;
  final int n;
  final String? size;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Input({
    this.prompt,
    this.n = 1,
    this.size,
    this.json,
  });

  factory Input.fromJson(Map<String, dynamic> json) {
    var result = _$InputFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$InputToJson(this);

  static Input fromJsonModel(Map<String, dynamic> json) => Input.fromJson(json);

  @override
  List<Object?> get props => [n, size, prompt];
}
