// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportDetailCWProxy {
  ReportDetail endDate(String? endDate);

  ReportDetail factory(Customer? factory);

  ReportDetail factoryId(String? factoryId);

  ReportDetail hashTags(List<ReportDetailHashTag>? hashTags);

  ReportDetail images(List<ReportDetailImage>? images);

  ReportDetail json(dynamic json);

  ReportDetail machine(Machine? machine);

  ReportDetail matricola(String? matricola);

  ReportDetail report(Report? report);

  ReportDetail reportDetailId(int? reportDetailId);

  ReportDetail reportId(int? reportId);

  ReportDetail startDate(String? startDate);

  ReportDetail summary(String? summary);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDetail call({
    String? endDate,
    Customer? factory,
    String? factoryId,
    List<ReportDetailHashTag>? hashTags,
    List<ReportDetailImage>? images,
    dynamic? json,
    Machine? machine,
    String? matricola,
    Report? report,
    int? reportDetailId,
    int? reportId,
    String? startDate,
    String? summary,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportDetail.copyWith.fieldName(...)`
class _$ReportDetailCWProxyImpl implements _$ReportDetailCWProxy {
  final ReportDetail _value;

  const _$ReportDetailCWProxyImpl(this._value);

  @override
  ReportDetail endDate(String? endDate) => this(endDate: endDate);

  @override
  ReportDetail factory(Customer? factory) => this(factory: factory);

  @override
  ReportDetail factoryId(String? factoryId) => this(factoryId: factoryId);

  @override
  ReportDetail hashTags(List<ReportDetailHashTag>? hashTags) =>
      this(hashTags: hashTags);

  @override
  ReportDetail images(List<ReportDetailImage>? images) => this(images: images);

  @override
  ReportDetail json(dynamic json) => this(json: json);

  @override
  ReportDetail machine(Machine? machine) => this(machine: machine);

  @override
  ReportDetail matricola(String? matricola) => this(matricola: matricola);

  @override
  ReportDetail report(Report? report) => this(report: report);

  @override
  ReportDetail reportDetailId(int? reportDetailId) =>
      this(reportDetailId: reportDetailId);

  @override
  ReportDetail reportId(int? reportId) => this(reportId: reportId);

  @override
  ReportDetail startDate(String? startDate) => this(startDate: startDate);

  @override
  ReportDetail summary(String? summary) => this(summary: summary);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportDetail call({
    Object? endDate = const $CopyWithPlaceholder(),
    Object? factory = const $CopyWithPlaceholder(),
    Object? factoryId = const $CopyWithPlaceholder(),
    Object? hashTags = const $CopyWithPlaceholder(),
    Object? images = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? machine = const $CopyWithPlaceholder(),
    Object? matricola = const $CopyWithPlaceholder(),
    Object? report = const $CopyWithPlaceholder(),
    Object? reportDetailId = const $CopyWithPlaceholder(),
    Object? reportId = const $CopyWithPlaceholder(),
    Object? startDate = const $CopyWithPlaceholder(),
    Object? summary = const $CopyWithPlaceholder(),
  }) {
    return ReportDetail(
      endDate: endDate == const $CopyWithPlaceholder()
          ? _value.endDate
          // ignore: cast_nullable_to_non_nullable
          : endDate as String?,
      factory: factory == const $CopyWithPlaceholder()
          ? _value.factory
          // ignore: cast_nullable_to_non_nullable
          : factory as Customer?,
      factoryId: factoryId == const $CopyWithPlaceholder()
          ? _value.factoryId
          // ignore: cast_nullable_to_non_nullable
          : factoryId as String?,
      hashTags: hashTags == const $CopyWithPlaceholder()
          ? _value.hashTags
          // ignore: cast_nullable_to_non_nullable
          : hashTags as List<ReportDetailHashTag>?,
      images: images == const $CopyWithPlaceholder()
          ? _value.images
          // ignore: cast_nullable_to_non_nullable
          : images as List<ReportDetailImage>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      machine: machine == const $CopyWithPlaceholder()
          ? _value.machine
          // ignore: cast_nullable_to_non_nullable
          : machine as Machine?,
      matricola: matricola == const $CopyWithPlaceholder()
          ? _value.matricola
          // ignore: cast_nullable_to_non_nullable
          : matricola as String?,
      report: report == const $CopyWithPlaceholder()
          ? _value.report
          // ignore: cast_nullable_to_non_nullable
          : report as Report?,
      reportDetailId: reportDetailId == const $CopyWithPlaceholder()
          ? _value.reportDetailId
          // ignore: cast_nullable_to_non_nullable
          : reportDetailId as int?,
      reportId: reportId == const $CopyWithPlaceholder()
          ? _value.reportId
          // ignore: cast_nullable_to_non_nullable
          : reportId as int?,
      startDate: startDate == const $CopyWithPlaceholder()
          ? _value.startDate
          // ignore: cast_nullable_to_non_nullable
          : startDate as String?,
      summary: summary == const $CopyWithPlaceholder()
          ? _value.summary
          // ignore: cast_nullable_to_non_nullable
          : summary as String?,
    );
  }
}

extension $ReportDetailCopyWith on ReportDetail {
  /// Returns a callable class that can be used as follows: `instanceOfReportDetail.copyWith(...)` or like so:`instanceOfReportDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportDetailCWProxy get copyWith => _$ReportDetailCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ReportDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportDetail(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ReportDetail copyWithNull({
    bool endDate = false,
    bool factory = false,
    bool factoryId = false,
    bool hashTags = false,
    bool images = false,
    bool machine = false,
    bool matricola = false,
    bool report = false,
    bool reportDetailId = false,
    bool reportId = false,
    bool startDate = false,
    bool summary = false,
  }) {
    return ReportDetail(
      endDate: endDate == true ? null : this.endDate,
      factory: factory == true ? null : this.factory,
      factoryId: factoryId == true ? null : this.factoryId,
      hashTags: hashTags == true ? null : this.hashTags,
      images: images == true ? null : this.images,
      json: json,
      machine: machine == true ? null : this.machine,
      matricola: matricola == true ? null : this.matricola,
      report: report == true ? null : this.report,
      reportDetailId: reportDetailId == true ? null : this.reportDetailId,
      reportId: reportId == true ? null : this.reportId,
      startDate: startDate == true ? null : this.startDate,
      summary: summary == true ? null : this.summary,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDetail _$ReportDetailFromJson(Map<String, dynamic> json) => ReportDetail(
      reportDetailId: json['reportDetailId'] as int?,
      factoryId: json['factoryId'] as String?,
      factory: json['factory'] == null
          ? null
          : Customer.fromJson(json['factory'] as Map<String, dynamic>),
      reportId: json['reportId'] as int?,
      report: json['report'] == null
          ? null
          : Report.fromJson(json['report'] as Map<String, dynamic>),
      summary: json['summary'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      matricola: json['matricola'] as String?,
      machine: json['machine'] == null
          ? null
          : Machine.fromJson(json['machine'] as Map<String, dynamic>),
      hashTags: (json['hashTags'] as List<dynamic>?)
          ?.map((e) => ReportDetailHashTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ReportDetailImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportDetailToJson(ReportDetail instance) =>
    <String, dynamic>{
      'hashTags': instance.hashTags,
      'images': instance.images,
      'reportDetailId': instance.reportDetailId,
      'reportId': instance.reportId,
      'report': instance.report,
      'factoryId': instance.factoryId,
      'factory': instance.factory,
      'summary': instance.summary,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'matricola': instance.matricola,
      'machine': instance.machine,
    };
