import 'package:json_annotation/json_annotation.dart';

import 'application_user.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(ignore: true)
  final String _name = "AuthResponse";
  @JsonKey(ignore: true)
  dynamic json;

  final ApplicationUser? user;
  final String? token;
  final String? refreshToken;

  AuthResponse({this.user, this.token, this.refreshToken, this.json});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    var result = _$AuthResponseFromJson(json);
    result.json = json;
    return result;
  }

  factory AuthResponse.fromJsonString(dynamic json) {
    return AuthResponse(
      user: ApplicationUser.fromJson(json['user']),
      token: json['token'],
      refreshToken: json['refreshToken'],
      json: json,
    );
  }

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      other is AuthResponse && other._name == _name;

  @override
  int get hashCode => _name.hashCode;
}