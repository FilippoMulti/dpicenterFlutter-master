import 'dart:typed_data';
import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';

part 'report_detail_image.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ReportDetailImage extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  ///bytes dell'immagine\video
  @JsonKey(ignore: true)
  final Uint8List? bytes;

  ///preview dell'immagine\video
  @JsonKey(ignore: true)
  final Uint8List? previewBytes;

  ///type:
  ///0 = image;
  ///1 = video
  @JsonKey(ignore: true)
  final int? type;

  @JsonKey(ignore: true)
  final Image? encodedImage;

  @JsonKey(ignore: true)
  final FilePickerResult? file;

  final int? reportDetailImageId;
  final int? reportDetailId;
  final ReportDetail? reportDetail;
  final String? image;

  final String? info;

  const ReportDetailImage(
      {this.reportDetailImageId,
      this.reportDetailId,
      this.reportDetail,
      this.image,
      this.info,
      this.bytes,
      this.type,
      this.file,
      this.encodedImage,
      this.previewBytes,
      this.json});

  factory ReportDetailImage.fromJson(Map<String, dynamic> json) {
    var result = _$ReportDetailImageFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportDetailImageToJson(this);

  static ReportDetailImage fromJsonModel(Map<String, dynamic> json) =>
      ReportDetailImage.fromJson(json);

  @override
  List<Object?> get props => [
        reportDetailId,
        reportDetailImageId,
        image,
        encodedImage,
        previewBytes,
        info,
        type,
        file
      ];
}
