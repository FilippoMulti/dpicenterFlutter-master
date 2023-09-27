import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'application_profile.g.dart';

@JsonSerializable()
@CopyWith()
class ApplicationProfile extends Equatable implements JsonPayload {
  final int? applicationProfileId;
  final String? profileName;
  final int? specialType;
  final List<ApplicationProfileEnabledMenu>? enabledMenus;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ApplicationProfile({
    this.applicationProfileId,
    this.profileName,
    this.specialType,
    this.enabledMenus,
    this.json,
  });

  factory ApplicationProfile.fromJson(Map<String, dynamic> json) {
    var result = _$ApplicationProfileFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ApplicationProfileToJson(this);

  static ApplicationProfile fromJsonModel(Map<String, dynamic> json) =>
      ApplicationProfile.fromJson(json);

  @override
  List<Object?> get props => [applicationProfileId, profileName, specialType];

/*@override
  bool operator ==(Object other) =>
      other is ApplicationProfile && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/
}
