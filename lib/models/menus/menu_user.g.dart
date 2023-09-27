// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMenu _$UserMenuFromJson(Map<String, dynamic> json) => UserMenu(
      applicationUserId: json['applicationUserId'] as int?,
      menuId: json['menuId'] as int?,
      sortOrder: json['sortOrder'] as int?,
    );

Map<String, dynamic> _$UserMenuToJson(UserMenu instance) => <String, dynamic>{
      'applicationUserId': instance.applicationUserId,
      'menuId': instance.menuId,
      'sortOrder': instance.sortOrder,
    };
