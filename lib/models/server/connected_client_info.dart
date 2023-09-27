import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/issue_attachment.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connected_client_info.g.dart';

@JsonSerializable()
@CopyWith()
class ConnectedClientInfo extends Equatable implements JsonPayload {
  final String? user;
  final String? ipAddress;
  final String? userAgent;
  final String? sessionId;
  final String? appVersion;
  final String? connectionDate;
  final String? currentOs;
  final String? currentDeviceName;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ConnectedClientInfo(
      {this.user,
      this.userAgent,
      this.ipAddress,
      this.sessionId,
      this.appVersion,
      this.connectionDate,
      this.currentOs,
      this.currentDeviceName,
      this.json});

  factory ConnectedClientInfo.fromJson(Map<String, dynamic> json) {
    var result = _$ConnectedClientInfoFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ConnectedClientInfoToJson(this);

  static ConnectedClientInfo fromJsonModel(Map<String, dynamic> json) =>
      ConnectedClientInfo.fromJson(json);

  @override
  List<Object?> get props => [
        user,
        userAgent,
        ipAddress,
        sessionId,
        appVersion,
        connectionDate,
        currentOs,
        currentDeviceName
      ];
}
