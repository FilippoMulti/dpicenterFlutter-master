import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'string_response.g.dart';

@JsonSerializable()
class StringResponse extends Equatable implements JsonPayload {
  final String response;

  StringResponse({required this.response, this.json});

  factory StringResponse.fromJson(Map<String, dynamic> json) {
    return _$StringResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StringResponseToJson(this);

  static StringResponse fromJsonModel(Map<String, dynamic> json) =>
      StringResponse.fromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [response];

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
