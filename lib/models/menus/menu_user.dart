import 'package:json_annotation/json_annotation.dart';

part 'menu_user.g.dart';

@JsonSerializable()
class UserMenu {
  ///dpi center backend url
  final int? applicationUserId;
  final int? menuId;
  final int? sortOrder;

  UserMenu({
    this.applicationUserId,
    this.menuId,
    this.sortOrder,
  });

  factory UserMenu.fromJson(Map<String, dynamic> json) =>
      _$UserMenuFromJson(json);

  Map<String, dynamic> toJson() => _$UserMenuToJson(this);
}
