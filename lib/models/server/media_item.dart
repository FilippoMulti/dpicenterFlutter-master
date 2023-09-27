import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/machine_production_file.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/machine_setting_file.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/media.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/vmc_file.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'media_item.g.dart';

///Questa classe dovrebbe sostituire ItemPicture e VmcFile

@JsonSerializable()
@CopyWith(copyWithNull: true)
class MediaItem extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int mediaItemId;
  final int parentId;
  final int mediaId;
  final Media? media;
  final String? description;

  const MediaItem(
      {required this.mediaItemId,
      required this.parentId,
      required this.mediaId,
      this.description,
      this.media,
      this.compressionId,
      this.json});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    var result = _$MediaItemFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MediaItemToJson(this);

  static MediaItem fromJsonModel(Map<String, dynamic> json) =>
      MediaItem.fromJson(json);

  @override
  List<Object?> get props => [
        mediaItemId,
        parentId,
        mediaId,
        description,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  SampleItemPicture toSampleItemPicture() {
    return SampleItemPicture(
        sampleItemPictureId: mediaItemId,
        sampleItemId: parentId,
        mediaId: mediaId,
        picture: media,
        description: description,
        compressionId: compressionId);
  }

  MachineProductionPicture toMachineProductionPicture() {
    return MachineProductionPicture(
        machineProductionPictureId: mediaItemId,
        machineProductionId: parentId,
        mediaId: mediaId,
        picture: media,
        description: description,
        compressionId: compressionId);
  }

  MachineSettingPicture toMachineSettingPicture() {
    return MachineSettingPicture(
        machineSettingPictureId: mediaItemId,
        machineSettingId: parentId,
        mediaId: mediaId,
        picture: media,
        description: description,
        compressionId: compressionId);
  }

  VmcFile toVmcFile() {
    return VmcFile(
        vmcFileId: mediaItemId,
        vmcId: parentId,
        mediaId: mediaId,
        description: description,
        file: media,
        compressionId: compressionId);
  }

  MachineSettingFile toMachineSettingFile() {
    return MachineSettingFile(
        machineSettingFileId: mediaItemId,
        machineSettingId: parentId,
        mediaId: mediaId,
        file: media,
        description: description,
        compressionId: compressionId);
  }

  MachineProductionFile toMachineProductionFile() {
    return MachineProductionFile(
        machineProductionFileId: mediaItemId,
        machineProductionId: parentId,
        mediaId: mediaId,
        file: media,
        description: description,
        compressionId: compressionId);
  }
}
