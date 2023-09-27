import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'machine_production_file.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith(copyWithNull: true)
class MachineProductionFile extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int machineProductionFileId;
  final int machineProductionId;
  final int mediaId;
  final Media? file;
  final String? description;

  const MachineProductionFile(
      {required this.machineProductionFileId,
      required this.machineProductionId,
      required this.mediaId,
      this.description,
      this.file,
      this.compressionId,
      this.json});

  factory MachineProductionFile.fromJson(Map<String, dynamic> json) {
    var result = _$MachineProductionFileFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineProductionFileToJson(this);

  static MachineProductionFile fromJsonModel(Map<String, dynamic> json) =>
      MachineProductionFile.fromJson(json);

  @override
  List<Object?> get props => [
        machineProductionId,
        machineProductionFileId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  MediaItem toMediaItem() {
    return MediaItem(
        mediaItemId: machineProductionFileId,
        parentId: machineProductionId,
        mediaId: mediaId,
        media: file,
        description: description,
        compressionId: compressionId);
  }
/*  ItemPicture toItemPicture() {
    return ItemPicture(
        itemPictureId: machineProductionPictureId,
        itemId: machineProductionId,
        description: description,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }*/
}
