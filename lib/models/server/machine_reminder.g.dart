// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_reminder.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MachineReminderCWProxy {
  MachineReminder json(dynamic json);

  MachineReminder machine(Machine? machine);

  MachineReminder machineReminderId(int? machineReminderId);

  MachineReminder matricola(String? matricola);

  MachineReminder position(int? position);

  MachineReminder reminder(Reminder? reminder);

  MachineReminder reminderId(int? reminderId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineReminder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineReminder(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineReminder call({
    dynamic? json,
    Machine? machine,
    int? machineReminderId,
    String? matricola,
    int? position,
    Reminder? reminder,
    int? reminderId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMachineReminder.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMachineReminder.copyWith.fieldName(...)`
class _$MachineReminderCWProxyImpl implements _$MachineReminderCWProxy {
  final MachineReminder _value;

  const _$MachineReminderCWProxyImpl(this._value);

  @override
  MachineReminder json(dynamic json) => this(json: json);

  @override
  MachineReminder machine(Machine? machine) => this(machine: machine);

  @override
  MachineReminder machineReminderId(int? machineReminderId) =>
      this(machineReminderId: machineReminderId);

  @override
  MachineReminder matricola(String? matricola) => this(matricola: matricola);

  @override
  MachineReminder position(int? position) => this(position: position);

  @override
  MachineReminder reminder(Reminder? reminder) => this(reminder: reminder);

  @override
  MachineReminder reminderId(int? reminderId) => this(reminderId: reminderId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineReminder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineReminder(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineReminder call({
    Object? json = const $CopyWithPlaceholder(),
    Object? machine = const $CopyWithPlaceholder(),
    Object? machineReminderId = const $CopyWithPlaceholder(),
    Object? matricola = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? reminder = const $CopyWithPlaceholder(),
    Object? reminderId = const $CopyWithPlaceholder(),
  }) {
    return MachineReminder(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      machine: machine == const $CopyWithPlaceholder()
          ? _value.machine
          // ignore: cast_nullable_to_non_nullable
          : machine as Machine?,
      machineReminderId: machineReminderId == const $CopyWithPlaceholder()
          ? _value.machineReminderId
          // ignore: cast_nullable_to_non_nullable
          : machineReminderId as int?,
      matricola: matricola == const $CopyWithPlaceholder()
          ? _value.matricola
          // ignore: cast_nullable_to_non_nullable
          : matricola as String?,
      position: position == const $CopyWithPlaceholder()
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as int?,
      reminder: reminder == const $CopyWithPlaceholder()
          ? _value.reminder
          // ignore: cast_nullable_to_non_nullable
          : reminder as Reminder?,
      reminderId: reminderId == const $CopyWithPlaceholder()
          ? _value.reminderId
          // ignore: cast_nullable_to_non_nullable
          : reminderId as int?,
    );
  }
}

extension $MachineReminderCopyWith on MachineReminder {
  /// Returns a callable class that can be used as follows: `instanceOfMachineReminder.copyWith(...)` or like so:`instanceOfMachineReminder.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MachineReminderCWProxy get copyWith => _$MachineReminderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineReminder _$MachineReminderFromJson(Map<String, dynamic> json) =>
    MachineReminder(
      machineReminderId: json['machineReminderId'] as int?,
      matricola: json['matricola'] as String?,
      machine: json['machine'] == null
          ? null
          : Machine.fromJson(json['machine'] as Map<String, dynamic>),
      reminderId: json['reminderId'] as int?,
      reminder: json['reminder'] == null
          ? null
          : Reminder.fromJson(json['reminder'] as Map<String, dynamic>),
      position: json['position'] as int?,
    );

Map<String, dynamic> _$MachineReminderToJson(MachineReminder instance) =>
    <String, dynamic>{
      'machineReminderId': instance.machineReminderId,
      'matricola': instance.matricola,
      'machine': instance.machine?.toJson(),
      'reminderId': instance.reminderId,
      'reminder': instance.reminder?.toJson(),
      'position': instance.position,
    };
