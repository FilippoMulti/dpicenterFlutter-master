import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'machine_note.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MachineNote extends Equatable implements JsonPayload {
  final int? machineNoteId;
  final String? matricola;
  final Machine? machine;
  final int? reminderConfigurationId;
  final ReminderConfiguration? noteConfiguration;
  final int? position;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const MachineNote({
    this.machineNoteId,
    this.matricola,
    this.machine,
    this.reminderConfigurationId,
    this.noteConfiguration,
    this.position,
    this.json,
  });

  factory MachineNote.fromJson(Map<String, dynamic> json) {
    var result = _$MachineNoteFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineNoteToJson(this);

  static MachineNote fromJsonModel(Map<String, dynamic> json) =>
      MachineNote.fromJson(json);

  @override
  List<Object?> get props => [
        machineNoteId,
        matricola,
        machine,
        reminderConfigurationId,
        noteConfiguration,
        position
      ];
}
