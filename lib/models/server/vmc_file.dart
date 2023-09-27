import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc_file.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcFile extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int vmcFileId;
  final int vmcId;
  final int mediaId;
  final Media? file;
  final String? description;

  const VmcFile(
      {required this.vmcFileId,
      required this.vmcId,
      required this.mediaId,
      this.description,
      this.file,
      this.compressionId,
      this.json});

  factory VmcFile.fromJson(Map<String, dynamic> json) {
    var result = _$VmcFileFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcFileToJson(this);

  static VmcFile fromJsonModel(Map<String, dynamic> json) =>
      VmcFile.fromJson(json);

  @override
  List<Object?> get props => [
        vmcFileId,
        vmcId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  MediaItem toMediaItem() {
    return MediaItem(
        mediaItemId: vmcFileId,
        parentId: vmcId,
        mediaId: mediaId,
        media: file,
        description: description,
        compressionId: compressionId);
  }
}
