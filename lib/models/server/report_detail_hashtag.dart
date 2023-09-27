import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_detail_hashtag.g.dart';


/*@JsonSerializable()
@freezed
class ReportDetailHashTag with _$ReportDetailHashTag {
  ///costruttore privato, permette di creare getter e setter con freezed
  const ReportDetailHashTag._();

  const factory ReportDetailHashTag(
      {int? reportHashTagId,
      int? reportDetailId,
      ReportDetail? reportDetail,
      int? hashTagId,
      HashTag? hashTag,
      @JsonKey(ignore: true) dynamic json}) = _ReportDetailHashTag;

  factory ReportDetailHashTag.fromJson(Map<String, dynamic> json) {
    var result = _$ReportDetailHashTagFromJson(json);
    result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportDetailHashTagToJson(this);

  static ReportDetailHashTag fromJsonModel(Map<String, dynamic> json) =>
      ReportDetailHashTag.fromJson(json);
}*/
@JsonSerializable()
@CopyWith(copyWithNull: true)
class ReportDetailHashTag extends Equatable {
  @JsonKey(ignore: true)
  final dynamic json;

  final int? reportHashTagId;
  final int? reportDetailId;
  final ReportDetail? reportDetail;
  final int? hashTagId;
  final HashTag? hashTag;

  const ReportDetailHashTag(
      {this.reportHashTagId,
      this.reportDetailId,
      this.reportDetail,
      this.hashTagId,
      this.hashTag,
      this.json});

  factory ReportDetailHashTag.fromJson(Map<String, dynamic> json) {
    var result = _$ReportDetailHashTagFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportDetailHashTagToJson(this);

  static ReportDetailHashTag fromJsonModel(Map<String, dynamic> json) =>
      ReportDetailHashTag.fromJson(json);

  /*@override
  bool operator ==(Object other) =>
      other is ReportDetailHashTag && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [reportDetailId, hashTagId];
}
