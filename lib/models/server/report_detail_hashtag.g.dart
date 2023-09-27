// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail_hashtag.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportDetailHashTagCWProxy {
  ReportDetailHashTag hashTag(HashTag? hashTag);

  ReportDetailHashTag hashTagId(int? hashTagId);

  ReportDetailHashTag json(dynamic json);

  ReportDetailHashTag reportDetail(ReportDetail? reportDetail);

  ReportDetailHashTag reportDetailId(int? reportDetailId);

  ReportDetailHashTag reportHashTagId(int? reportHashTagId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDetailHashTag(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetailHashTag(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDetailHashTag call({
    HashTag? hashTag,
    int? hashTagId,
    dynamic? json,
    ReportDetail? reportDetail,
    int? reportDetailId,
    int? reportHashTagId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportDetailHashTag.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportDetailHashTag.copyWith.fieldName(...)`
class _$ReportDetailHashTagCWProxyImpl implements _$ReportDetailHashTagCWProxy {
  final ReportDetailHashTag _value;

  const _$ReportDetailHashTagCWProxyImpl(this._value);

  @override
  ReportDetailHashTag hashTag(HashTag? hashTag) => this(hashTag: hashTag);

  @override
  ReportDetailHashTag hashTagId(int? hashTagId) => this(hashTagId: hashTagId);

  @override
  ReportDetailHashTag json(dynamic json) => this(json: json);

  @override
  ReportDetailHashTag reportDetail(ReportDetail? reportDetail) =>
      this(reportDetail: reportDetail);

  @override
  ReportDetailHashTag reportDetailId(int? reportDetailId) =>
      this(reportDetailId: reportDetailId);

  @override
  ReportDetailHashTag reportHashTagId(int? reportHashTagId) =>
      this(reportHashTagId: reportHashTagId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDetailHashTag(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetailHashTag(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDetailHashTag call({
    Object? hashTag = const $CopyWithPlaceholder(),
    Object? hashTagId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? reportDetail = const $CopyWithPlaceholder(),
    Object? reportDetailId = const $CopyWithPlaceholder(),
    Object? reportHashTagId = const $CopyWithPlaceholder(),
  }) {
    return ReportDetailHashTag(
      hashTag: hashTag == const $CopyWithPlaceholder()
          ? _value.hashTag
          // ignore: cast_nullable_to_non_nullable
          : hashTag as HashTag?,
      hashTagId: hashTagId == const $CopyWithPlaceholder()
          ? _value.hashTagId
          // ignore: cast_nullable_to_non_nullable
          : hashTagId as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      reportDetail: reportDetail == const $CopyWithPlaceholder()
          ? _value.reportDetail
          // ignore: cast_nullable_to_non_nullable
          : reportDetail as ReportDetail?,
      reportDetailId: reportDetailId == const $CopyWithPlaceholder()
          ? _value.reportDetailId
          // ignore: cast_nullable_to_non_nullable
          : reportDetailId as int?,
      reportHashTagId: reportHashTagId == const $CopyWithPlaceholder()
          ? _value.reportHashTagId
          // ignore: cast_nullable_to_non_nullable
          : reportHashTagId as int?,
    );
  }
}

extension $ReportDetailHashTagCopyWith on ReportDetailHashTag {
  /// Returns a callable class that can be used as follows: `instanceOfReportDetailHashTag.copyWith(...)` or like so:`instanceOfReportDetailHashTag.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportDetailHashTagCWProxy get copyWith =>
      _$ReportDetailHashTagCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ReportDetailHashTag(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetailHashTag(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ReportDetailHashTag copyWithNull({
    bool hashTag = false,
    bool hashTagId = false,
    bool reportDetail = false,
    bool reportDetailId = false,
    bool reportHashTagId = false,
  }) {
    return ReportDetailHashTag(
      hashTag: hashTag == true ? null : this.hashTag,
      hashTagId: hashTagId == true ? null : this.hashTagId,
      json: json,
      reportDetail: reportDetail == true ? null : this.reportDetail,
      reportDetailId: reportDetailId == true ? null : this.reportDetailId,
      reportHashTagId: reportHashTagId == true ? null : this.reportHashTagId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDetailHashTag _$ReportDetailHashTagFromJson(Map<String, dynamic> json) =>
    ReportDetailHashTag(
      reportHashTagId: json['reportHashTagId'] as int?,
      reportDetailId: json['reportDetailId'] as int?,
      reportDetail: json['reportDetail'] == null
          ? null
          : ReportDetail.fromJson(json['reportDetail'] as Map<String, dynamic>),
      hashTagId: json['hashTagId'] as int?,
      hashTag: json['hashTag'] == null
          ? null
          : HashTag.fromJson(json['hashTag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportDetailHashTagToJson(
        ReportDetailHashTag instance) =>
    <String, dynamic>{
      'reportHashTagId': instance.reportHashTagId,
      'reportDetailId': instance.reportDetailId,
      'reportDetail': instance.reportDetail,
      'hashTagId': instance.hashTagId,
      'hashTag': instance.hashTag,
    };
