// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_profile_enabled_menu.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationProfileEnabledMenuCWProxy {
  ApplicationProfileEnabledMenu applicationProfileEnabledMenuId(
      int? applicationProfileEnabledMenuId);

  ApplicationProfileEnabledMenu applicationProfileId(int? applicationProfileId);

  ApplicationProfileEnabledMenu json(dynamic json);

  ApplicationProfileEnabledMenu menu(Menu? menu);

  ApplicationProfileEnabledMenu menuId(int? menuId);

  ApplicationProfileEnabledMenu status(int? status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationProfileEnabledMenu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationProfileEnabledMenu(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationProfileEnabledMenu call({
    int? applicationProfileEnabledMenuId,
    int? applicationProfileId,
    dynamic? json,
    Menu? menu,
    int? menuId,
    int? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationProfileEnabledMenu.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationProfileEnabledMenu.copyWith.fieldName(...)`
class _$ApplicationProfileEnabledMenuCWProxyImpl
    implements _$ApplicationProfileEnabledMenuCWProxy {
  final ApplicationProfileEnabledMenu _value;

  const _$ApplicationProfileEnabledMenuCWProxyImpl(this._value);

  @override
  ApplicationProfileEnabledMenu applicationProfileEnabledMenuId(
          int? applicationProfileEnabledMenuId) =>
      this(applicationProfileEnabledMenuId: applicationProfileEnabledMenuId);

  @override
  ApplicationProfileEnabledMenu applicationProfileId(
          int? applicationProfileId) =>
      this(applicationProfileId: applicationProfileId);

  @override
  ApplicationProfileEnabledMenu json(dynamic json) => this(json: json);

  @override
  ApplicationProfileEnabledMenu menu(Menu? menu) => this(menu: menu);

  @override
  ApplicationProfileEnabledMenu menuId(int? menuId) => this(menuId: menuId);

  @override
  ApplicationProfileEnabledMenu status(int? status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationProfileEnabledMenu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationProfileEnabledMenu(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationProfileEnabledMenu call({
    Object? applicationProfileEnabledMenuId = const $CopyWithPlaceholder(),
    Object? applicationProfileId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? menu = const $CopyWithPlaceholder(),
    Object? menuId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return ApplicationProfileEnabledMenu(
      applicationProfileEnabledMenuId:
          applicationProfileEnabledMenuId == const $CopyWithPlaceholder()
              ? _value.applicationProfileEnabledMenuId
              // ignore: cast_nullable_to_non_nullable
              : applicationProfileEnabledMenuId as int?,
      applicationProfileId: applicationProfileId == const $CopyWithPlaceholder()
          ? _value.applicationProfileId
          // ignore: cast_nullable_to_non_nullable
          : applicationProfileId as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      menu: menu == const $CopyWithPlaceholder()
          ? _value.menu
          // ignore: cast_nullable_to_non_nullable
          : menu as Menu?,
      menuId: menuId == const $CopyWithPlaceholder()
          ? _value.menuId
          // ignore: cast_nullable_to_non_nullable
          : menuId as int?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int?,
    );
  }
}

extension $ApplicationProfileEnabledMenuCopyWith
    on ApplicationProfileEnabledMenu {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationProfileEnabledMenu.copyWith(...)` or like so:`instanceOfApplicationProfileEnabledMenu.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationProfileEnabledMenuCWProxy get copyWith =>
      _$ApplicationProfileEnabledMenuCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationProfileEnabledMenu _$ApplicationProfileEnabledMenuFromJson(
        Map<String, dynamic> json) =>
    ApplicationProfileEnabledMenu(
      applicationProfileId: json['applicationProfileId'] as int?,
      applicationProfileEnabledMenuId:
          json['applicationProfileEnabledMenuId'] as int?,
      menuId: json['menuId'] as int?,
      status: json['status'] as int?,
      menu: json['menu'] == null
          ? null
          : Menu.fromJson(json['menu'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationProfileEnabledMenuToJson(
        ApplicationProfileEnabledMenu instance) =>
    <String, dynamic>{
      'applicationProfileEnabledMenuId':
          instance.applicationProfileEnabledMenuId,
      'status': instance.status,
      'applicationProfileId': instance.applicationProfileId,
      'menuId': instance.menuId,
      'menu': instance.menu,
    };
