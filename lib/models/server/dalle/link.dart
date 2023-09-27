import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'link.g.dart';

@JsonSerializable()
@CopyWith()
class Link extends Equatable implements JsonPayload {
  final String? url;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Link({
    this.url,
    this.json,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    var result = _$LinkFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$LinkToJson(this);

  static Link fromJsonModel(Map<String, dynamic> json) => Link.fromJson(json);

  @override
  List<Object?> get props => [url];
}
