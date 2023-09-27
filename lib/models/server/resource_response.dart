import 'dart:convert';
import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resource_response.g.dart';

@JsonSerializable()
@CopyWith()
class ResourceResponse extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final String name;
  final String? contents;

  @JsonKey(ignore: true)
  final Uint8List? decodedContents;

  const ResourceResponse(
      {required this.name, this.contents, this.json, this.decodedContents});

  factory ResourceResponse.fromJson(Map<String, dynamic> json) {
    var result = _$ResourceResponseFromJson(json);
    if (result.contents != null) {
      result = result.copyWith(decodedContents: base64Decode(result.contents!));
    }
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ResourceResponseToJson(this);

  static ResourceResponse fromJsonModel(Map<String, dynamic> json) =>
      ResourceResponse.fromJson(json);

  @override
  List<Object?> get props => [name, contents];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
