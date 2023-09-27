// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail_image.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportDetailImageCWProxy {
  ReportDetailImage bytes(Uint8List? bytes);

  ReportDetailImage encodedImage(Image? encodedImage);

  ReportDetailImage file(FilePickerResult? file);

  ReportDetailImage image(String? image);

  ReportDetailImage info(String? info);

  ReportDetailImage json(dynamic json);

  ReportDetailImage previewBytes(Uint8List? previewBytes);

  ReportDetailImage reportDetail(ReportDetail? reportDetail);

  ReportDetailImage reportDetailId(int? reportDetailId);

  ReportDetailImage reportDetailImageId(int? reportDetailImageId);

  ReportDetailImage type(int? type);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDetailImage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetailImage(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDetailImage call({
    Uint8List? bytes,
    Image? encodedImage,
    FilePickerResult? file,
    String? image,
    String? info,
    dynamic? json,
    Uint8List? previewBytes,
    ReportDetail? reportDetail,
    int? reportDetailId,
    int? reportDetailImageId,
    int? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportDetailImage.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportDetailImage.copyWith.fieldName(...)`
class _$ReportDetailImageCWProxyImpl implements _$ReportDetailImageCWProxy {
  final ReportDetailImage _value;

  const _$ReportDetailImageCWProxyImpl(this._value);

  @override
  ReportDetailImage bytes(Uint8List? bytes) => this(bytes: bytes);

  @override
  ReportDetailImage encodedImage(Image? encodedImage) =>
      this(encodedImage: encodedImage);

  @override
  ReportDetailImage file(FilePickerResult? file) => this(file: file);

  @override
  ReportDetailImage image(String? image) => this(image: image);

  @override
  ReportDetailImage info(String? info) => this(info: info);

  @override
  ReportDetailImage json(dynamic json) => this(json: json);

  @override
  ReportDetailImage previewBytes(Uint8List? previewBytes) =>
      this(previewBytes: previewBytes);

  @override
  ReportDetailImage reportDetail(ReportDetail? reportDetail) =>
      this(reportDetail: reportDetail);

  @override
  ReportDetailImage reportDetailId(int? reportDetailId) =>
      this(reportDetailId: reportDetailId);

  @override
  ReportDetailImage reportDetailImageId(int? reportDetailImageId) =>
      this(reportDetailImageId: reportDetailImageId);

  @override
  ReportDetailImage type(int? type) => this(type: type);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDetailImage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetailImage(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDetailImage call({
    Object? bytes = const $CopyWithPlaceholder(),
    Object? encodedImage = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? info = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? previewBytes = const $CopyWithPlaceholder(),
    Object? reportDetail = const $CopyWithPlaceholder(),
    Object? reportDetailId = const $CopyWithPlaceholder(),
    Object? reportDetailImageId = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return ReportDetailImage(
      bytes: bytes == const $CopyWithPlaceholder()
          ? _value.bytes
          // ignore: cast_nullable_to_non_nullable
          : bytes as Uint8List?,
      encodedImage: encodedImage == const $CopyWithPlaceholder()
          ? _value.encodedImage
          // ignore: cast_nullable_to_non_nullable
          : encodedImage as Image?,
      file: file == const $CopyWithPlaceholder()
          ? _value.file
          // ignore: cast_nullable_to_non_nullable
          : file as FilePickerResult?,
      image: image == const $CopyWithPlaceholder()
          ? _value.image
          // ignore: cast_nullable_to_non_nullable
          : image as String?,
      info: info == const $CopyWithPlaceholder()
          ? _value.info
          // ignore: cast_nullable_to_non_nullable
          : info as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      previewBytes: previewBytes == const $CopyWithPlaceholder()
          ? _value.previewBytes
          // ignore: cast_nullable_to_non_nullable
          : previewBytes as Uint8List?,
      reportDetail: reportDetail == const $CopyWithPlaceholder()
          ? _value.reportDetail
          // ignore: cast_nullable_to_non_nullable
          : reportDetail as ReportDetail?,
      reportDetailId: reportDetailId == const $CopyWithPlaceholder()
          ? _value.reportDetailId
          // ignore: cast_nullable_to_non_nullable
          : reportDetailId as int?,
      reportDetailImageId: reportDetailImageId == const $CopyWithPlaceholder()
          ? _value.reportDetailImageId
          // ignore: cast_nullable_to_non_nullable
          : reportDetailImageId as int?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as int?,
    );
  }
}

extension $ReportDetailImageCopyWith on ReportDetailImage {
  /// Returns a callable class that can be used as follows: `instanceOfReportDetailImage.copyWith(...)` or like so:`instanceOfReportDetailImage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportDetailImageCWProxy get copyWith =>
      _$ReportDetailImageCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ReportDetailImage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetailImage(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ReportDetailImage copyWithNull({
    bool bytes = false,
    bool encodedImage = false,
    bool file = false,
    bool image = false,
    bool info = false,
    bool previewBytes = false,
    bool reportDetail = false,
    bool reportDetailId = false,
    bool reportDetailImageId = false,
    bool type = false,
  }) {
    return ReportDetailImage(
      bytes: bytes == true ? null : this.bytes,
      encodedImage: encodedImage == true ? null : this.encodedImage,
      file: file == true ? null : this.file,
      image: image == true ? null : this.image,
      info: info == true ? null : this.info,
      json: json,
      previewBytes: previewBytes == true ? null : this.previewBytes,
      reportDetail: reportDetail == true ? null : this.reportDetail,
      reportDetailId: reportDetailId == true ? null : this.reportDetailId,
      reportDetailImageId:
          reportDetailImageId == true ? null : this.reportDetailImageId,
      type: type == true ? null : this.type,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDetailImage _$ReportDetailImageFromJson(Map<String, dynamic> json) =>
    ReportDetailImage(
      reportDetailImageId: json['reportDetailImageId'] as int?,
      reportDetailId: json['reportDetailId'] as int?,
      reportDetail: json['reportDetail'] == null
          ? null
          : ReportDetail.fromJson(json['reportDetail'] as Map<String, dynamic>),
      image: json['image'] as String?,
      info: json['info'] as String?,
    );

Map<String, dynamic> _$ReportDetailImageToJson(ReportDetailImage instance) =>
    <String, dynamic>{
      'reportDetailImageId': instance.reportDetailImageId,
      'reportDetailId': instance.reportDetailId,
      'reportDetail': instance.reportDetail,
      'image': instance.image,
      'info': instance.info,
    };
