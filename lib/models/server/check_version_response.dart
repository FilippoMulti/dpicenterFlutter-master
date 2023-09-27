
import 'package:json_annotation/json_annotation.dart';

part 'check_version_response.g.dart';

@JsonSerializable()
class CheckVersionResponse {
  @JsonKey(ignore: true)
  final String _name = "CheckVersionResponse";

  final int version;
  final String versionString;
  final int? serverVersion;
  final String? serverVersionString;
  final String message;
  final bool force;

  CheckVersionResponse(
      {required this.version,
      required this.versionString,
      this.serverVersion,
      this.serverVersionString,
      required this.message,
      required this.force});

  factory CheckVersionResponse.fromJson(Map<String, dynamic> json) {
    return _$CheckVersionResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CheckVersionResponseToJson(this);

  static CheckVersionResponse fromJsonModel(Map<String, dynamic> json) =>
      CheckVersionResponse.fromJson(json);

  factory CheckVersionResponse.fromJsonString(dynamic json) {
    return CheckVersionResponse(
      version: int.parse(json['version'].toString()),
      versionString: json['versionString'],
      message: json['message'],
      serverVersion: int.parse(json['serverVersion'].toString()),
      serverVersionString: json['serverVersionString'],
      force: json['force'].parseBool(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CheckVersionResponse && other._name == _name;

  @override
  int get hashCode => _name.hashCode;
}
