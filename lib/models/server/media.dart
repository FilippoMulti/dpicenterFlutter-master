import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/media_item.dart';

import 'package:dpicenter/models/server/mixin/mixin_json.dart';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class Media extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int? mediaId;
  final String? content;
  final String name;
  final String? description;

  @JsonKey(ignore: true)
  final PlatformFile? file;

  ///bytes dell'immagine\video
  @JsonKey(ignore: true)
  final Uint8List? bytes;

  ///preview dell'immagine\video
  @JsonKey(ignore: true)
  final Uint8List? previewBytes;

  ///id compressione, utilizzato per ritrovare l'elemento durante la compressione
  @JsonKey(ignore: true)
  final int? compressionId;

  const Media(
      {this.mediaId,
      this.compressionId,
      this.content,
      required this.name,
      this.description,
      this.file,
      this.bytes,
      this.previewBytes,
      this.json});

  factory Media.fromJson(Map<String, dynamic> json) {
    var result = _$MediaFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MediaToJson(this);

  static Media fromJsonModel(Map<String, dynamic> json) => Media.fromJson(json);

  @override
  List<Object?> get props => [
        mediaId,
        content,
        description,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  MediaItem toMediaItem() {
    return MediaItem(
      mediaId: mediaId ?? 0,
      media: this,
      mediaItemId: 0,
      parentId: 0,
      description: description,
    );
  }
}
