import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'machine_setting_file.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith(copyWithNull: true)
class MachineSettingFile extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int machineSettingFileId;
  final int machineSettingId;
  final int mediaId;
  final Media? file;
  final String? description;

  const MachineSettingFile(
      {required this.machineSettingFileId,
      required this.machineSettingId,
      required this.mediaId,
      this.description,
      this.file,
      this.compressionId,
      this.json});

  factory MachineSettingFile.fromJson(Map<String, dynamic> json) {
    var result = _$MachineSettingFileFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineSettingFileToJson(this);

  static MachineSettingFile fromJsonModel(Map<String, dynamic> json) =>
      MachineSettingFile.fromJson(json);

  @override
  List<Object?> get props => [
        machineSettingId,
        machineSettingFileId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  MediaItem toMediaItem() {
    return MediaItem(
        mediaItemId: machineSettingFileId,
        parentId: machineSettingId,
        mediaId: mediaId,
        media: file,
        description: description,
        compressionId: compressionId);
  }
/*  VmcFile toItemPicture() {
    return VmcFile(
        itemPictureId: machineSettingPictureId,
        itemId: machineSettingId,
        description: description,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }*/
}
