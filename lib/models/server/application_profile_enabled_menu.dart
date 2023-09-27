import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'application_profile_enabled_menu.g.dart';

@JsonSerializable()
@CopyWith()
class ApplicationProfileEnabledMenu extends Equatable implements JsonPayload {
  final int? applicationProfileEnabledMenuId;
  final int? status;
  final int? applicationProfileId;
  final int? menuId;
  final Menu? menu;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ApplicationProfileEnabledMenu({
    this.applicationProfileId,
    this.applicationProfileEnabledMenuId,
    this.menuId,
    this.status,
    this.menu,
    this.json,
  });

  factory ApplicationProfileEnabledMenu.fromJson(Map<String, dynamic> json) {
    var result = _$ApplicationProfileEnabledMenuFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ApplicationProfileEnabledMenuToJson(this);

  static ApplicationProfileEnabledMenu fromJsonModel(
          Map<String, dynamic> json) =>
      ApplicationProfileEnabledMenu.fromJson(json);

  @override
  List<Object?> get props => [
        applicationProfileId,
        applicationProfileEnabledMenuId,
        menuId,
        menu,
        status
      ];
}
