import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_attachment.g.dart';

@JsonSerializable()
@CopyWith()
class IssueAttachment extends Equatable implements JsonPayload {
  final String? name;
  final String? content;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const IssueAttachment({this.name, this.content, this.json});

  factory IssueAttachment.fromJson(Map<String, dynamic> json) {
    var result = _$IssueAttachmentFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$IssueAttachmentToJson(this);

  static IssueAttachment fromJsonModel(Map<String, dynamic> json) =>
      IssueAttachment.fromJson(json);

  @override
  List<Object?> get props => [name, content];
}
