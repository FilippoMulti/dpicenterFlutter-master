// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReminderCWProxy {
  Reminder applicationUser(ApplicationUser? applicationUser);

  Reminder applicationUserId(int? applicationUserId);

  Reminder date(String? date);

  Reminder deadline(String? deadline);

  Reminder json(dynamic json);

  Reminder reminderConfiguration(ReminderConfiguration? reminderConfiguration);

  Reminder reminderConfigurationId(int? reminderConfigurationId);

  Reminder reminderId(int reminderId);

  Reminder state(int? state);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reminder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reminder(...).copyWith(id: 12, name: "My name")
  /// ````
  Reminder call({
    ApplicationUser? applicationUser,
    int? applicationUserId,
    String? date,
    String? deadline,
    dynamic? json,
    ReminderConfiguration? reminderConfiguration,
    int? reminderConfigurationId,
    int? reminderId,
    int? state,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReminder.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReminder.copyWith.fieldName(...)`
class _$ReminderCWProxyImpl implements _$ReminderCWProxy {
  final Reminder _value;

  const _$ReminderCWProxyImpl(this._value);

  @override
  Reminder applicationUser(ApplicationUser? applicationUser) =>
      this(applicationUser: applicationUser);

  @override
  Reminder applicationUserId(int? applicationUserId) =>
      this(applicationUserId: applicationUserId);

  @override
  Reminder date(String? date) => this(date: date);

  @override
  Reminder deadline(String? deadline) => this(deadline: deadline);

  @override
  Reminder json(dynamic json) => this(json: json);

  @override
  Reminder reminderConfiguration(
          ReminderConfiguration? reminderConfiguration) =>
      this(reminderConfiguration: reminderConfiguration);

  @override
  Reminder reminderConfigurationId(int? reminderConfigurationId) =>
      this(reminderConfigurationId: reminderConfigurationId);

  @override
  Reminder reminderId(int reminderId) => this(reminderId: reminderId);

  @override
  Reminder state(int? state) => this(state: state);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reminder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reminder(...).copyWith(id: 12, name: "My name")
  /// ````
  Reminder call({
    Object? applicationUser = const $CopyWithPlaceholder(),
    Object? applicationUserId = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? reminderConfiguration = const $CopyWithPlaceholder(),
    Object? reminderConfigurationId = const $CopyWithPlaceholder(),
    Object? reminderId = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
  }) {
    return Reminder(
      applicationUser: applicationUser == const $CopyWithPlaceholder()
          ? _value.applicationUser
          // ignore: cast_nullable_to_non_nullable
          : applicationUser as ApplicationUser?,
      applicationUserId: applicationUserId == const $CopyWithPlaceholder()
          ? _value.applicationUserId
          // ignore: cast_nullable_to_non_nullable
          : applicationUserId as int?,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String?,
      deadline: deadline == const $CopyWithPlaceholder()
          ? _value.deadline
          // ignore: cast_nullable_to_non_nullable
          : deadline as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      reminderConfiguration:
          reminderConfiguration == const $CopyWithPlaceholder()
              ? _value.reminderConfiguration
              // ignore: cast_nullable_to_non_nullable
              : reminderConfiguration as ReminderConfiguration?,
      reminderConfigurationId:
          reminderConfigurationId == const $CopyWithPlaceholder()
              ? _value.reminderConfigurationId
              // ignore: cast_nullable_to_non_nullable
              : reminderConfigurationId as int?,
      reminderId:
          reminderId == const $CopyWithPlaceholder() || reminderId == null
              ? _value.reminderId
              // ignore: cast_nullable_to_non_nullable
              : reminderId as int,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as int?,
    );
  }
}

extension $ReminderCopyWith on Reminder {
  /// Returns a callable class that can be used as follows: `instanceOfReminder.copyWith(...)` or like so:`instanceOfReminder.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReminderCWProxy get copyWith => _$ReminderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      reminderId: json['reminderId'] as int,
      reminderConfiguration: json['reminderConfiguration'] == null
          ? null
          : ReminderConfiguration.fromJson(
              json['reminderConfiguration'] as Map<String, dynamic>),
      date: json['date'] as String?,
      deadline: json['deadline'] as String?,
      reminderConfigurationId: json['reminderConfigurationId'] as int?,
      state: json['state'] as int?,
      applicationUserId: json['applicationUserId'] as int?,
      applicationUser: json['applicationUser'] == null
          ? null
          : ApplicationUser.fromJson(
              json['applicationUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'reminderId': instance.reminderId,
      'date': instance.date,
      'deadline': instance.deadline,
      'reminderConfigurationId': instance.reminderConfigurationId,
      'reminderConfiguration': instance.reminderConfiguration?.toJson(),
      'state': instance.state,
      'applicationUserId': instance.applicationUserId,
      'applicationUser': instance.applicationUser?.toJson(),
    };
