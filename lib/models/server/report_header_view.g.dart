// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_header_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportHeaderViewCWProxy {
  ReportHeaderView customer(String? customer);

  ReportHeaderView date(String? date);

  ReportHeaderView factories(String? factories);

  ReportHeaderView hashtags(String? hashtags);

  ReportHeaderView interventionCause(String? interventionCause);

  ReportHeaderView json(dynamic json);

  ReportHeaderView report(Report? report);

  ReportHeaderView reportId(int? reportId);

  ReportHeaderView reportUsers(String? reportUsers);

  ReportHeaderView status(int? status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportHeaderView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportHeaderView(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportHeaderView call({
    String? customer,
    String? date,
    String? factories,
    String? hashtags,
    String? interventionCause,
    dynamic? json,
    Report? report,
    int? reportId,
    String? reportUsers,
    int? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportHeaderView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportHeaderView.copyWith.fieldName(...)`
class _$ReportHeaderViewCWProxyImpl implements _$ReportHeaderViewCWProxy {
  final ReportHeaderView _value;

  const _$ReportHeaderViewCWProxyImpl(this._value);

  @override
  ReportHeaderView customer(String? customer) => this(customer: customer);

  @override
  ReportHeaderView date(String? date) => this(date: date);

  @override
  ReportHeaderView factories(String? factories) => this(factories: factories);

  @override
  ReportHeaderView hashtags(String? hashtags) => this(hashtags: hashtags);

  @override
  ReportHeaderView interventionCause(String? interventionCause) =>
      this(interventionCause: interventionCause);

  @override
  ReportHeaderView json(dynamic json) => this(json: json);

  @override
  ReportHeaderView report(Report? report) => this(report: report);

  @override
  ReportHeaderView reportId(int? reportId) => this(reportId: reportId);

  @override
  ReportHeaderView reportUsers(String? reportUsers) =>
      this(reportUsers: reportUsers);

  @override
  ReportHeaderView status(int? status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportHeaderView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportHeaderView(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportHeaderView call({
    Object? customer = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? factories = const $CopyWithPlaceholder(),
    Object? hashtags = const $CopyWithPlaceholder(),
    Object? interventionCause = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? report = const $CopyWithPlaceholder(),
    Object? reportId = const $CopyWithPlaceholder(),
    Object? reportUsers = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return ReportHeaderView(
      customer: customer == const $CopyWithPlaceholder()
          ? _value.customer
          // ignore: cast_nullable_to_non_nullable
          : customer as String?,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String?,
      factories: factories == const $CopyWithPlaceholder()
          ? _value.factories
          // ignore: cast_nullable_to_non_nullable
          : factories as String?,
      hashtags: hashtags == const $CopyWithPlaceholder()
          ? _value.hashtags
          // ignore: cast_nullable_to_non_nullable
          : hashtags as String?,
      interventionCause: interventionCause == const $CopyWithPlaceholder()
          ? _value.interventionCause
          // ignore: cast_nullable_to_non_nullable
          : interventionCause as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      report: report == const $CopyWithPlaceholder()
          ? _value.report
          // ignore: cast_nullable_to_non_nullable
          : report as Report?,
      reportId: reportId == const $CopyWithPlaceholder()
          ? _value.reportId
          // ignore: cast_nullable_to_non_nullable
          : reportId as int?,
      reportUsers: reportUsers == const $CopyWithPlaceholder()
          ? _value.reportUsers
          // ignore: cast_nullable_to_non_nullable
          : reportUsers as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int?,
    );
  }
}

extension $ReportHeaderViewCopyWith on ReportHeaderView {
  /// Returns a callable class that can be used as follows: `instanceOfReportHeaderView.copyWith(...)` or like so:`instanceOfReportHeaderView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportHeaderViewCWProxy get copyWith => _$ReportHeaderViewCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ReportHeaderView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportHeaderView(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ReportHeaderView copyWithNull({
    bool customer = false,
    bool date = false,
    bool factories = false,
    bool hashtags = false,
    bool interventionCause = false,
    bool report = false,
    bool reportId = false,
    bool reportUsers = false,
    bool status = false,
  }) {
    return ReportHeaderView(
      customer: customer == true ? null : this.customer,
      date: date == true ? null : this.date,
      factories: factories == true ? null : this.factories,
      hashtags: hashtags == true ? null : this.hashtags,
      interventionCause:
          interventionCause == true ? null : this.interventionCause,
      json: json,
      report: report == true ? null : this.report,
      reportId: reportId == true ? null : this.reportId,
      reportUsers: reportUsers == true ? null : this.reportUsers,
      status: status == true ? null : this.status,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportHeaderView _$ReportHeaderViewFromJson(Map<String, dynamic> json) =>
    ReportHeaderView(
      reportId: json['reportId'] as int?,
      reportUsers: json['reportUsers'] as String?,
      date: json['date'] as String?,
      customer: json['customer'] as String?,
      factories: json['factories'] as String?,
      interventionCause: json['interventionCause'] as String?,
      status: json['status'] as int?,
      hashtags: json['hashtags'] as String?,
    );

Map<String, dynamic> _$ReportHeaderViewToJson(ReportHeaderView instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'reportUsers': instance.reportUsers,
      'date': instance.date,
      'customer': instance.customer,
      'factories': instance.factories,
      'interventionCause': instance.interventionCause,
      'status': instance.status,
      'hashtags': instance.hashtags,
    };
