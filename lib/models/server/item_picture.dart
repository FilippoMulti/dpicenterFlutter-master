import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/media.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'item_picture.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ItemPicture extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int itemPictureId;
  final int itemId;
  final int mediaId;
  final Media? picture;
  final String? description;

  const ItemPicture(
      {required this.itemPictureId,
      required this.itemId,
      required this.mediaId,
      this.description,
      this.picture,
      this.compressionId,
      this.json});

  factory ItemPicture.fromJson(Map<String, dynamic> json) {
    var result = _$ItemPictureFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ItemPictureToJson(this);

  static ItemPicture fromJsonModel(Map<String, dynamic> json) =>
      ItemPicture.fromJson(json);

  @override
  List<Object?> get props =>
      [
        itemPictureId,
        itemId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  SampleItemPicture toSampleItemPicture() {
    return SampleItemPicture(
        sampleItemPictureId: itemPictureId,
        sampleItemId: itemId,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }

  MachineProductionPicture toMachineProdutionPicture() {
    return MachineProductionPicture(
        machineProductionPictureId: itemPictureId,
        machineProductionId: itemId,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }

  MachineSettingPicture toMachineSettingPicture() {
    return MachineSettingPicture(
        machineSettingPictureId: itemPictureId,
        machineSettingId: itemId,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }
}
