import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'machine_production_picture.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith(copyWithNull: true)
class MachineProductionPicture extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int machineProductionPictureId;
  final int machineProductionId;
  final int mediaId;
  final Media? picture;
  final String? description;

  const MachineProductionPicture(
      {required this.machineProductionPictureId,
      required this.machineProductionId,
      required this.mediaId,
      this.description,
      this.picture,
      this.compressionId,
      this.json});

  factory MachineProductionPicture.fromJson(Map<String, dynamic> json) {
    var result = _$MachineProductionPictureFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineProductionPictureToJson(this);

  static MachineProductionPicture fromJsonModel(Map<String, dynamic> json) =>
      MachineProductionPicture.fromJson(json);

  @override
  List<Object?> get props => [
        machineProductionId,
        machineProductionPictureId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  ItemPicture toItemPicture() {
    return ItemPicture(
        itemPictureId: machineProductionPictureId,
        itemId: machineProductionId,
        description: description,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }
}
