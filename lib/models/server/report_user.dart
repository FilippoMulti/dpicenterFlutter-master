import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_user.g.dart';


/*@JsonSerializable()
@freezed
class ReportUser with _$ReportUser {
  const ReportUser._();

  const factory ReportUser(
      {int? reportUserId,
      int? reportId,
      int? applicationUserId,
      ApplicationUser? applicationUser,
      Report? report,
      @JsonKey(ignore: true) dynamic json}) = _ReportUser;

  factory ReportUser.fromJson(Map<String, dynamic> json) {
    var result = _$ReportUserFromJson(json);
    result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportUserToJson(this);

  static ReportUser fromJsonModel(Map<String, dynamic> json) =>
      ReportUser.fromJson(json);
}*/

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ReportUser extends Equatable {
  @JsonKey(ignore: true)
  final dynamic json;

  final int? reportUserId;
  final int? reportId;
  final int? applicationUserId;
  final ApplicationUser? applicationUser;
  final Report? report;

  const ReportUser(
      {this.reportUserId,
      this.reportId,
      this.applicationUserId,
      this.applicationUser,
      this.report,
      this.json});

  factory ReportUser.fromJson(Map<String, dynamic> json) {
    var result = _$ReportUserFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReportUserToJson(this);

  static ReportUser fromJsonModel(Map<String, dynamic> json) =>
      ReportUser.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [reportUserId, reportId, applicationUserId];
}
