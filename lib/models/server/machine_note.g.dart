// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_note.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MachineNoteCWProxy {
  MachineNote json(dynamic json);

  MachineNote machine(Machine? machine);

  MachineNote machineNoteId(int? machineNoteId);

  MachineNote matricola(String? matricola);

  MachineNote noteConfiguration(ReminderConfiguration? noteConfiguration);

  MachineNote position(int? position);

  MachineNote reminderConfigurationId(int? reminderConfigurationId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineNote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineNote(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineNote call({
    dynamic? json,
    Machine? machine,
    int? machineNoteId,
    String? matricola,
    ReminderConfiguration? noteConfiguration,
    int? position,
    int? reminderConfigurationId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMachineNote.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMachineNote.copyWith.fieldName(...)`
class _$MachineNoteCWProxyImpl implements _$MachineNoteCWProxy {
  final MachineNote _value;

  const _$MachineNoteCWProxyImpl(this._value);

  @override
  MachineNote json(dynamic json) => this(json: json);

  @override
  MachineNote machine(Machine? machine) => this(machine: machine);

  @override
  MachineNote machineNoteId(int? machineNoteId) =>
      this(machineNoteId: machineNoteId);

  @override
  MachineNote matricola(String? matricola) => this(matricola: matricola);

  @override
  MachineNote noteConfiguration(ReminderConfiguration? noteConfiguration) =>
      this(noteConfiguration: noteConfiguration);

  @override
  MachineNote position(int? position) => this(position: position);

  @override
  MachineNote reminderConfigurationId(int? reminderConfigurationId) =>
      this(reminderConfigurationId: reminderConfigurationId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MachineNote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MachineNote(...).copyWith(id: 12, name: "My name")
  /// ````
  MachineNote call({
    Object? json = const $CopyWithPlaceholder(),
    Object? machine = const $CopyWithPlaceholder(),
    Object? machineNoteId = const $CopyWithPlaceholder(),
    Object? matricola = const $CopyWithPlaceholder(),
    Object? noteConfiguration = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? reminderConfigurationId = const $CopyWithPlaceholder(),
  }) {
    return MachineNote(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      machine: machine == const $CopyWithPlaceholder()
          ? _value.machine
          // ignore: cast_nullable_to_non_nullable
          : machine as Machine?,
      machineNoteId: machineNoteId == const $CopyWithPlaceholder()
          ? _value.machineNoteId
          // ignore: cast_nullable_to_non_nullable
          : machineNoteId as int?,
      matricola: matricola == const $CopyWithPlaceholder()
          ? _value.matricola
          // ignore: cast_nullable_to_non_nullable
          : matricola as String?,
      noteConfiguration: noteConfiguration == const $CopyWithPlaceholder()
          ? _value.noteConfiguration
          // ignore: cast_nullable_to_non_nullable
          : noteConfiguration as ReminderConfiguration?,
      position: position == const $CopyWithPlaceholder()
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as int?,
      reminderConfigurationId:
          reminderConfigurationId == const $CopyWithPlaceholder()
              ? _value.reminderConfigurationId
              // ignore: cast_nullable_to_non_nullable
              : reminderConfigurationId as int?,
    );
  }
}

extension $MachineNoteCopyWith on MachineNote {
  /// Returns a callable class that can be used as follows: `instanceOfMachineNote.copyWith(...)` or like so:`instanceOfMachineNote.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MachineNoteCWProxy get copyWith => _$MachineNoteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineNote _$MachineNoteFromJson(Map<String, dynamic> json) => MachineNote(
      machineNoteId: json['machineNoteId'] as int?,
      matricola: json['matricola'] as String?,
      machine: json['machine'] == null
          ? null
          : Machine.fromJson(json['machine'] as Map<String, dynamic>),
      reminderConfigurationId: json['reminderConfigurationId'] as int?,
      noteConfiguration: json['noteConfiguration'] == null
          ? null
          : ReminderConfiguration.fromJson(
              json['noteConfiguration'] as Map<String, dynamic>),
      position: json['position'] as int?,
    );

Map<String, dynamic> _$MachineNoteToJson(MachineNote instance) =>
    <String, dynamic>{
      'machineNoteId': instance.machineNoteId,
      'matricola': instance.matricola,
      'machine': instance.machine?.toJson(),
      'reminderConfigurationId': instance.reminderConfigurationId,
      'noteConfiguration': instance.noteConfiguration?.toJson(),
      'position': instance.position,
    };
