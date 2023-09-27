import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';

part 'application_user_detail.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class ApplicationUserDetail extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  final int? applicationUserDetailId;
  final int? applicationUserId;
  final String? image;
  final String? thumbImage;

  @JsonKey(ignore: true)
  final ImageProvider? imageProvider;

  const ApplicationUserDetail(
      {this.applicationUserDetailId,
      this.applicationUserId,
      this.image,
      this.imageProvider,
      this.thumbImage,
      this.json});

  factory ApplicationUserDetail.fromJson(Map<String, dynamic> json) {
    ApplicationUserDetail result = _$ApplicationUserDetailFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ApplicationUserDetailToJson(this);

  static ApplicationUserDetail fromJsonModel(Map<String, dynamic> json) =>
      ApplicationUserDetail.fromJson(json);

  @override
  List<Object?> get props =>
      [applicationUserId, applicationUserDetailId, image, thumbImage];

  static ApplicationUserDetail? getImageFromSetting() {
    String? json = prefs?.getString(userDetailInfoSetting);
    if (json != null) {
      return ApplicationUserDetail.fromJson(jsonDecode(json));
    }

    return null;
  }
}
