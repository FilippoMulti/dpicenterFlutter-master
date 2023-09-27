import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/issue_attachment.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_model.g.dart';

@JsonSerializable()
@CopyWith()
class IssueModel extends Equatable implements JsonPayload {
  final String? title;
  final String? message;
  final List<IssueAttachment>? issueAttachments;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const IssueModel(
      {this.title, this.message, this.issueAttachments, this.json});

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    var result = _$IssueModelFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$IssueModelToJson(this);

  static IssueModel fromJsonModel(Map<String, dynamic> json) =>
      IssueModel.fromJson(json);

  @override
  List<Object?> get props => [title, message, issueAttachments];
}
