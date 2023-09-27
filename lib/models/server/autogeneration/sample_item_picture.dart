import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'sample_item_picture.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class SampleItemPicture extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///lo utilizzo per generare un id temporaneo e ritrovare l'elemento
  @JsonKey(ignore: true)
  final int? compressionId;

  final int sampleItemPictureId;
  final int sampleItemId;
  final int mediaId;
  final Media? picture;
  final String? description;

  const SampleItemPicture(
      {required this.sampleItemPictureId,
      required this.sampleItemId,
      required this.mediaId,
      this.description,
      this.picture,
      this.compressionId,
      this.json});

  factory SampleItemPicture.fromJson(Map<String, dynamic> json) {
    var result = _$SampleItemPictureFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$SampleItemPictureToJson(this);

  static SampleItemPicture fromJsonModel(Map<String, dynamic> json) =>
      SampleItemPicture.fromJson(json);

  @override
  List<Object?> get props =>
      [
        sampleItemPictureId,
        sampleItemId,
        mediaId,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  ItemPicture toItemPicture() {
    return ItemPicture(
        itemPictureId: sampleItemPictureId,
        itemId: sampleItemId,
        description: description,
        mediaId: mediaId,
        picture: picture,
        compressionId: compressionId);
  }
}
