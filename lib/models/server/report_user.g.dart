// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportUserCWProxy {
  ReportUser applicationUser(ApplicationUser? applicationUser);

  ReportUser applicationUserId(int? applicationUserId);

  ReportUser json(dynamic json);

  ReportUser report(Report? report);

  ReportUser reportId(int? reportId);

  ReportUser reportUserId(int? reportUserId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportUser(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportUser call({
    ApplicationUser? applicationUser,
    int? applicationUserId,
    dynamic? json,
    Report? report,
    int? reportId,
    int? reportUserId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportUser.copyWith.fieldName(...)`
class _$ReportUserCWProxyImpl implements _$ReportUserCWProxy {
  final ReportUser _value;

  const _$ReportUserCWProxyImpl(this._value);

  @override
  ReportUser applicationUser(ApplicationUser? applicationUser) =>
      this(applicationUser: applicationUser);

  @override
  ReportUser applicationUserId(int? applicationUserId) =>
      this(applicationUserId: applicationUserId);

  @override
  ReportUser json(dynamic json) => this(json: json);

  @override
  ReportUser report(Report? report) => this(report: report);

  @override
  ReportUser reportId(int? reportId) => this(reportId: reportId);

  @override
  ReportUser reportUserId(int? reportUserId) =>
      this(reportUserId: reportUserId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportUser(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportUser call({
    Object? applicationUser = const $CopyWithPlaceholder(),
    Object? applicationUserId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? report = const $CopyWithPlaceholder(),
    Object? reportId = const $CopyWithPlaceholder(),
    Object? reportUserId = const $CopyWithPlaceholder(),
  }) {
    return ReportUser(
      applicationUser: applicationUser == const $CopyWithPlaceholder()
          ? _value.applicationUser
          // ignore: cast_nullable_to_non_nullable
          : applicationUser as ApplicationUser?,
      applicationUserId: applicationUserId == const $CopyWithPlaceholder()
          ? _value.applicationUserId
          // ignore: cast_nullable_to_non_nullable
          : applicationUserId as int?,
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
      reportUserId: reportUserId == const $CopyWithPlaceholder()
          ? _value.reportUserId
          // ignore: cast_nullable_to_non_nullable
          : reportUserId as int?,
    );
  }
}

extension $ReportUserCopyWith on ReportUser {
  /// Returns a callable class that can be used as follows: `instanceOfReportUser.copyWith(...)` or like so:`instanceOfReportUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportUserCWProxy get copyWith => _$ReportUserCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `ReportUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportUser(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  ReportUser copyWithNull({
    bool applicationUser = false,
    bool applicationUserId = false,
    bool report = false,
    bool reportId = false,
    bool reportUserId = false,
  }) {
    return ReportUser(
      applicationUser: applicationUser == true ? null : this.applicationUser,
      applicationUserId:
          applicationUserId == true ? null : this.applicationUserId,
      json: json,
      report: report == true ? null : this.report,
      reportId: reportId == true ? null : this.reportId,
      reportUserId: reportUserId == true ? null : this.reportUserId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportUser _$ReportUserFromJson(Map<String, dynamic> json) => ReportUser(
      reportUserId: json['reportUserId'] as int?,
      reportId: json['reportId'] as int?,
      applicationUserId: json['applicationUserId'] as int?,
      applicationUser: json['applicationUser'] == null
          ? null
          : ApplicationUser.fromJson(
              json['applicationUser'] as Map<String, dynamic>),
      report: json['report'] == null
          ? null
          : Report.fromJson(json['report'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportUserToJson(ReportUser instance) =>
    <String, dynamic>{
      'reportUserId': instance.reportUserId,
      'reportId': instance.reportId,
      'applicationUserId': instance.applicationUserId,
      'applicationUser': instance.applicationUser,
      'report': instance.report,
    };
