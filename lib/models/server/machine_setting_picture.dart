import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'machine_setting_picture.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith(copyWithNull: true)
class MachineSettingPicture extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int machineSettingPictureId;
  final int machineSettingId;
  final int mediaId;
  final Media? picture;
  final String? description;

  const MachineSettingPicture(
      {required this.machineSettingPictureId,
      required this.machineSettingId,
      required this.mediaId,
      this.description,
      this.picture,
      this.compressionId,
      this.json});

  factory MachineSettingPicture.fromJson(Map<String, dynamic> json) {
    var result = _$MachineSettingPictureFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineSettingPictureToJson(this);

  static MachineSettingPicture fromJsonModel(Map<String, dynamic> json) =>
      MachineSettingPicture.fromJson(json);

  @override
  List<Object?> get props => [
        machineSettingId,
        machineSettingPictureId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  ItemPicture toItemPicture() {
    return ItemPicture(
        itemPictureId: machineSettingPictureId,
        itemId: machineSettingId,
        description: description,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }
}
