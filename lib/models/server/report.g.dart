// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportCWProxy {
  Report creationDate(String? creationDate);

  Report customer(Customer? customer);

  Report customerId(String? customerId);

  Report interventionCause(InterventionCause? interventionCause);

  Report interventionCauseId(int? interventionCauseId);

  Report json(dynamic json);

  Report referent(String? referent);

  Report reportDetails(List<ReportDetail>? reportDetails);

  Report reportId(int? reportId);

  Report reportUsers(List<ReportUser>? reportUsers);

  Report signature(String? signature);

  Report signaturePoints(String? signaturePoints);

  Report status(int status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Report(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Report(...).copyWith(id: 12, name: "My name")
  /// ````
  Report call({
    String? creationDate,
    Customer? customer,
    String? customerId,
    InterventionCause? interventionCause,
    int? interventionCauseId,
    dynamic? json,
    String? referent,
    List<ReportDetail>? reportDetails,
    int? reportId,
    List<ReportUser>? reportUsers,
    String? signature,
    String? signaturePoints,
    int? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReport.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReport.copyWith.fieldName(...)`
class _$ReportCWProxyImpl implements _$ReportCWProxy {
  final Report _value;

  const _$ReportCWProxyImpl(this._value);

  @override
  Report creationDate(String? creationDate) => this(creationDate: creationDate);

  @override
  Report customer(Customer? customer) => this(customer: customer);

  @override
  Report customerId(String? customerId) => this(customerId: customerId);

  @override
  Report interventionCause(InterventionCause? interventionCause) =>
      this(interventionCause: interventionCause);

  @override
  Report interventionCauseId(int? interventionCauseId) =>
      this(interventionCauseId: interventionCauseId);

  @override
  Report json(dynamic json) => this(json: json);

  @override
  Report referent(String? referent) => this(referent: referent);

  @override
  Report reportDetails(List<ReportDetail>? reportDetails) =>
      this(reportDetails: reportDetails);

  @override
  Report reportId(int? reportId) => this(reportId: reportId);

  @override
  Report reportUsers(List<ReportUser>? reportUsers) =>
      this(reportUsers: reportUsers);

  @override
  Report signature(String? signature) => this(signature: signature);

  @override
  Report signaturePoints(String? signaturePoints) =>
      this(signaturePoints: signaturePoints);

  @override
  Report status(int status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Report(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Report(...).copyWith(id: 12, name: "My name")
  /// ````
  Report call({
    Object? creationDate = const $CopyWithPlaceholder(),
    Object? customer = const $CopyWithPlaceholder(),
    Object? customerId = const $CopyWithPlaceholder(),
    Object? interventionCause = const $CopyWithPlaceholder(),
    Object? interventionCauseId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? referent = const $CopyWithPlaceholder(),
    Object? reportDetails = const $CopyWithPlaceholder(),
    Object? reportId = const $CopyWithPlaceholder(),
    Object? reportUsers = const $CopyWithPlaceholder(),
    Object? signature = const $CopyWithPlaceholder(),
    Object? signaturePoints = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return Report(
      creationDate: creationDate == const $CopyWithPlaceholder()
          ? _value.creationDate
          // ignore: cast_nullable_to_non_nullable
          : creationDate as String?,
      customer: customer == const $CopyWithPlaceholder()
          ? _value.customer
          // ignore: cast_nullable_to_non_nullable
          : customer as Customer?,
      customerId: customerId == const $CopyWithPlaceholder()
          ? _value.customerId
          // ignore: cast_nullable_to_non_nullable
          : customerId as String?,
      interventionCause: interventionCause == const $CopyWithPlaceholder()
          ? _value.interventionCause
          // ignore: cast_nullable_to_non_nullable
          : interventionCause as InterventionCause?,
      interventionCauseId: interventionCauseId == const $CopyWithPlaceholder()
          ? _value.interventionCauseId
          // ignore: cast_nullable_to_non_nullable
          : interventionCauseId as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      referent: referent == const $CopyWithPlaceholder()
          ? _value.referent
          // ignore: cast_nullable_to_non_nullable
          : referent as String?,
      reportDetails: reportDetails == const $CopyWithPlaceholder()
          ? _value.reportDetails
          // ignore: cast_nullable_to_non_nullable
          : reportDetails as List<ReportDetail>?,
      reportId: reportId == const $CopyWithPlaceholder()
          ? _value.reportId
          // ignore: cast_nullable_to_non_nullable
          : reportId as int?,
      reportUsers: reportUsers == const $CopyWithPlaceholder()
          ? _value.reportUsers
          // ignore: cast_nullable_to_non_nullable
          : reportUsers as List<ReportUser>?,
      signature: signature == const $CopyWithPlaceholder()
          ? _value.signature
          // ignore: cast_nullable_to_non_nullable
          : signature as String?,
      signaturePoints: signaturePoints == const $CopyWithPlaceholder()
          ? _value.signaturePoints
          // ignore: cast_nullable_to_non_nullable
          : signaturePoints as String?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int,
    );
  }
}

extension $ReportCopyWith on Report {
  /// Returns a callable class that can be used as follows: `instanceOfReport.copyWith(...)` or like so:`instanceOfReport.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportCWProxy get copyWith => _$ReportCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `Report(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Report(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  Report copyWithNull({
    bool creationDate = false,
    bool customer = false,
    bool customerId = false,
    bool interventionCause = false,
    bool interventionCauseId = false,
    bool referent = false,
    bool reportDetails = false,
    bool reportId = false,
    bool reportUsers = false,
    bool signature = false,
    bool signaturePoints = false,
  }) {
    return Report(
      creationDate: creationDate == true ? null : this.creationDate,
      customer: customer == true ? null : this.customer,
      customerId: customerId == true ? null : this.customerId,
      interventionCause:
          interventionCause == true ? null : this.interventionCause,
      interventionCauseId:
          interventionCauseId == true ? null : this.interventionCauseId,
      json: json,
      referent: referent == true ? null : this.referent,
      reportDetails: reportDetails == true ? null : this.reportDetails,
      reportId: reportId == true ? null : this.reportId,
      reportUsers: reportUsers == true ? null : this.reportUsers,
      signature: signature == true ? null : this.signature,
      signaturePoints: signaturePoints == true ? null : this.signaturePoints,
      status: status,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      reportId: json['reportId'] as int?,
      creationDate: json['creationDate'] as String?,
      customerId: json['customerId'] as String?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      interventionCauseId: json['interventionCauseId'] as int?,
      interventionCause: json['interventionCause'] == null
          ? null
          : InterventionCause.fromJson(
              json['interventionCause'] as Map<String, dynamic>),
      status: json['status'] as int? ?? 0,
      reportUsers: (json['reportUsers'] as List<dynamic>?)
          ?.map((e) => ReportUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportDetails: (json['reportDetails'] as List<dynamic>?)
          ?.map((e) => ReportDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      signature: json['signature'] as String?,
      signaturePoints: json['signaturePoints'] as String?,
      referent: json['referent'] as String?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'reportUsers': instance.reportUsers,
      'reportDetails': instance.reportDetails,
      'reportId': instance.reportId,
      'creationDate': instance.creationDate,
      'customerId': instance.customerId,
      'customer': instance.customer,
      'interventionCauseId': instance.interventionCauseId,
      'interventionCause': instance.interventionCause,
      'status': instance.status,
      'signature': instance.signature,
      'signaturePoints': instance.signaturePoints,
      'referent': instance.referent,
    };
