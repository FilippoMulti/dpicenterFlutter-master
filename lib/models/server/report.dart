import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/intervention_cause.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'report.g.dart';

//part 'report.freezed.dart';

/*@JsonSerializable()
@freezed
class Report with _$Report {
  const Report._();

  const factory Report(
      {int? reportId,
      String? creationDate,
      String? customerId,
      Customer? customer,
      int? interventionCauseId,
      InterventionCause? interventionCause,
      @JsonKey(ignore: true) dynamic json,
      @Default(0) int? status,
      List<ReportUser>? reportUsers,
      List<ReportDetail>? reportDetails}) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) {
    return _$ReportFromJson(json).copyWith(json: json);
  }

  Map<String, dynamic> toJson() => _$ReportToJson(this);

  static Report fromJsonModel(Map<String, dynamic> json) =>
      Report.fromJson(json);

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        reportId,
        creationDate,
        customerId,
        customer,
        interventionCauseId,
        interventionCause,
        status,
        reportUsers,
        reportDetails);
  }

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
  }
}*/

@JsonSerializable()
@CopyWith(copyWithNull: true)
class Report extends Equatable implements JsonPayload {
  final List<ReportUser>? reportUsers;

  final List<ReportDetail>? reportDetails;

  final int? reportId;
  final String? creationDate;
  final String? customerId;
  final Customer? customer;
  final int? interventionCauseId;
  final InterventionCause? interventionCause;
  final int status;
  final String? signature;
  final String? signaturePoints;
  final String? referent;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Report(
      {this.reportId,
      this.creationDate,
      this.customerId,
      this.customer,
      this.interventionCauseId,
      this.interventionCause,
      this.status = 0,
      this.reportUsers,
      this.reportDetails,
      this.signature,
      this.signaturePoints,
      this.referent,
      this.json});

  factory Report.fromJson(Map<String, dynamic> json) {
    var result = _$ReportFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportToJson(this);

  static Report fromJsonModel(Map<String, dynamic> json) =>
      Report.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is Report && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  Status getStatus() {
    //se c'è almeno un lavoro e una firma ed è stato selezionato un cliente, un intervention cause e aleno un operatore
    //l'intervento è chiuso
    if ((reportDetails?.isNotEmpty ?? false) &&
        (customerId != null) &&
        (interventionCauseId != null) &&
        (reportUsers?.isNotEmpty ?? false) &&
        (signature?.isNotEmpty ?? false)) {
      debugPrint("Status.closed");
      return Status.closed;
    }
    //se c'è almeno un lavoro o una firma e un cliente un intervenion cause un operatore
    //l'intervento è iniziato
    if (((reportDetails?.isNotEmpty ?? false) ||
            (signature?.isNotEmpty ?? false)) &&
        (customerId != null) &&
        (interventionCauseId != null) &&
        (reportUsers?.isNotEmpty ?? false)) {
      debugPrint("Status.started");
      return Status.started;
    }
    //se c'è almeno un cliente un intervention cause un operatore
    //l'intervento è aperto
    if ((customerId != null) &&
        (interventionCauseId != null) &&
        (reportUsers?.isNotEmpty ?? false)) {
      debugPrint("Status.open");
      return Status.open;
    }

    debugPrint("Status.initState");
    return Status.initState;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        reportUsers,
        reportId,
        creationDate,
        customerId,
        interventionCauseId,
        status,
        signature,
        signaturePoints,
        referent
      ];
}
enum Status { initState, open, started, closed }