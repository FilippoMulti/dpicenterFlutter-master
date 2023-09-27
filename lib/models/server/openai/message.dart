import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'message.g.dart';

@JsonSerializable()
@CopyWith()
class Message extends Equatable implements JsonPayload {
  final String? role;
  final String? content;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Message({
    this.role,
    this.content,
    this.json,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    var result = _$MessageFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static Message fromJsonModel(Map<String, dynamic> json) =>
      Message.fromJson(json);

  @override
  List<Object?> get props => [
        role,
        content,
      ];
}
