import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail_hashtag.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';
import 'machine.dart';
import 'mixin/mixin_json.dart';

part 'report_detail.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ReportDetail extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  final List<ReportDetailHashTag>? hashTags;
  final List<ReportDetailImage>? images;

  final int? reportDetailId;
  final int? reportId;
  final Report? report;

  final String? factoryId;
  final Customer? factory;
  final String? summary;
  final String? startDate;
  final String? endDate;
  final String? matricola;
  final Machine? machine;

  const ReportDetail(
      {this.reportDetailId,
      this.factoryId,
      this.factory,
      this.reportId,
      this.report,
      this.summary,
      this.startDate,
      this.endDate,
      this.matricola,
      this.machine,
      this.hashTags,
      this.images,
      this.json});

  factory ReportDetail.fromJson(Map<String, dynamic> json) {
    var result = _$ReportDetailFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  factory ReportDetail.test({required int reportDetailId}) {
    String summary = 'test lavoro ${reportDetailId.toString()}';
    String startDate = '2021-11-20T08:00:00z';
    String endDate = '2021-12-20T12:00:00z';

    return ReportDetail(
        reportDetailId: reportDetailId,
        startDate: startDate,
        endDate: endDate,
        summary: summary);
  }

  Map<String, dynamic> toJson() => _$ReportDetailToJson(this);

  static ReportDetail fromJsonModel(Map<String, dynamic> json) =>
      ReportDetail.fromJson(json);

  ReportDetail cloneAsNew() {
    return ReportDetail(
        reportDetailId: 0,
        factoryId: factoryId,
        factory: factory,
        reportId: reportId,
        report: report,
        summary: summary,
        startDate: startDate,
        endDate: endDate,
        matricola: matricola,
        machine: machine,
        hashTags: hashTags
            ?.map((e) => e.copyWith(
                reportDetailId: 0,
                reportHashTagId: 0,
                reportDetail: null,
                hashTagId: e.hashTagId))
            .toList(growable: false),
        images: images);
  }

  /*@override
  bool operator ==(Object other) =>
      other is ReportDetail &&
          other._name == _name &&
          other.reportDetailId == reportDetailId &&
          other.summary == summary &&
          other.startDate == startDate &&
          other.endDate == endDate &&
          other.hashTags == hashTags;

  @override
  int get hashCode =>
      Object.hash(_name, reportDetailId, summary, startDate, endDate, hashTags);*/

  @override
  List<Object?> get props => [
        reportDetailId,
        factoryId,
        reportId,
        summary,
        startDate,
        endDate,
        matricola,
        hashTags,
        images
      ];
}
