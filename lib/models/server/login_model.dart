import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String _name = "LoginModel";
  @JsonKey(includeFromJson: false, includeToJson: false)
  dynamic json;

  String? userName;
  String? password;

  LoginModel({this.userName, this.password, this.json});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

  @override
  bool operator ==(Object other) => other is LoginModel && other._name == _name;

  @override
  int get hashCode => _name.hashCode;
}
