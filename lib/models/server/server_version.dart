import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_version.g.dart';

@JsonSerializable()
@CopyWith()
class ServerVersion extends Equatable {
  @JsonKey(ignore: true)
  final dynamic json;

  final int versionNumber;
  final String currentVersion;

  const ServerVersion(
      {required this.versionNumber, required this.currentVersion, this.json});

  factory ServerVersion.fromJson(Map<String, dynamic> json) {
    var result = _$ServerVersionFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ServerVersionToJson(this);

  static ServerVersion fromJsonModel(Map<String, dynamic> json) =>
      ServerVersion.fromJson(json);

  @override
  List<Object?> get props => [versionNumber, currentVersion];
}
