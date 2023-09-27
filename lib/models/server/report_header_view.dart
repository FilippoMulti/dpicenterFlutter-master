import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/intervention_cause.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'report_header_view.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ReportHeaderView extends Equatable implements JsonPayload {
  final int? reportId;
  final String? reportUsers;
  final String? date;
  final String? customer;
  final String? factories;
  final String? interventionCause;
  final int? status;
  final String? hashtags;

  @JsonKey(ignore: true)
  final Report? report;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ReportHeaderView(
      {this.reportId,
      this.reportUsers,
      this.date,
      this.customer,
      this.factories,
      this.interventionCause,
      this.status,
      this.hashtags,
      this.report,
      this.json});

  factory ReportHeaderView.fromJson(Map<String, dynamic> json) {
    var result = _$ReportHeaderViewFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportHeaderViewToJson(this);

  static ReportHeaderView fromJsonModel(Map<String, dynamic> json) =>
      ReportHeaderView.fromJson(json);

  @override
  List<Object?> get props => [
        reportUsers,
        reportId,
        date,
        customer,
        interventionCause,
        status,
        factories,
        hashtags,
        report,
      ];
}
