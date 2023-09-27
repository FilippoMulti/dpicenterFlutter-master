import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'doc_frame.g.dart';

@JsonSerializable()
@CopyWith()
class DocFrame extends Equatable implements JsonPayload {
  final int? id;
  final int? dataframeId;
  final String? title;
  final String? content;
  final String? section;
  final String? audio;
  final bool generate;
  final String? attachments;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const DocFrame({
    this.id,
    this.dataframeId,
    this.title,
    this.content,
    this.section,
    this.generate = true,
    this.audio,
    this.attachments,
    this.json,
  });

  factory DocFrame.fromJson(Map<String, dynamic> json) {
    var result = _$DocFrameFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$DocFrameToJson(this);

  static DocFrame fromJsonModel(Map<String, dynamic> json) =>
      DocFrame.fromJson(json);

  @override
  List<Object?> get props => [
        id,
        dataframeId,
        title,
        content,
        section,
        generate,
        audio,
        attachments,
      ];
}
