import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/server/application_profile.dart';
import 'package:dpicenter/models/server/application_user_detail.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_user.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ApplicationUser extends Equatable implements JsonPayload, Comparable {
  final int? applicationUserId;
  final String? userName;
  final String? surname;
  final String? name;
  final String? password;
  final String? theme;
  final int? applicationProfileId;
  final ApplicationProfile? profile;
  final String? refreshToken;

  final List<ApplicationUserDetail>? userDetails;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ApplicationUser(
      {this.applicationUserId,
      this.userName,
      this.password,
      this.theme,
      this.applicationProfileId,
      this.profile,
      this.refreshToken,
      this.surname,
      this.name,
      this.userDetails,
      this.json});

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    ApplicationUser result = _$ApplicationUserFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ApplicationUserToJson(this);

  static ApplicationUser fromJsonModel(Map<String, dynamic> json) =>
      ApplicationUser.fromJson(json);

  @override
  List<Object?> get props =>
      [
        applicationUserId,
        userName,
        password,
        theme,
        applicationProfileId,
        refreshToken,
        surname,
        name,
        profile,
        userDetails
      ];

  static ApplicationUser? getUserFromSetting() {
    String? json = prefs?.getString(userInfoSetting);

    if (json != null) {
      ApplicationUser loaded = ApplicationUser.fromJson(jsonDecode(json));
      return loaded;
    }

    return null;
  }

  @override
  int compareTo(other) {
    if (other is ApplicationUser) {
      return applicationUserId?.compareTo(other.applicationUserId ?? -1) ?? -1;
    }
    return -1;
    throw UnimplementedError();
  }
}
