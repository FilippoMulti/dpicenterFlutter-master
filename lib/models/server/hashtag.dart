import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';

part 'hashtag.g.dart';

@JsonSerializable()
@CopyWith()
class HashTag extends Equatable implements JsonPayload, Comparable {
  final int? hashTagId;
  final String? name;
  final String? description;
  final String? color;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const HashTag(
      {this.hashTagId, this.name, this.description, this.color, this.json});

  factory HashTag.fromJson(Map<String, dynamic> json) {
    var result = _$HashTagFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$HashTagToJson(this);

  static HashTag fromJsonModel(Map<String, dynamic> json) =>
      HashTag.fromJson(json);

  @override
  List<Object?> get props => [hashTagId, name, description, color];

  @override
  int compareTo(other) {
    if (other is HashTag) {
      if (name == null) {
        return 1;
      }
      if (other.name == null) {
        return -1;
      }
      return name!.toLowerCase().compareTo(other.name!.toLowerCase());
    }
    return 0;
  }
}
