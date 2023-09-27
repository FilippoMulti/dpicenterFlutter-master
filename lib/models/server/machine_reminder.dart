import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'machine_reminder.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MachineReminder extends Equatable implements JsonPayload {
  final int? machineReminderId;
  final String? matricola;
  final Machine? machine;
  final int? reminderId;
  final Reminder? reminder;
  final int? position;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const MachineReminder({
    this.machineReminderId,
    this.matricola,
    this.machine,
    this.reminderId,
    this.reminder,
    this.position,
    this.json,
  });

  factory MachineReminder.fromJson(Map<String, dynamic> json) {
    var result = _$MachineReminderFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineReminderToJson(this);

  static MachineReminder fromJsonModel(Map<String, dynamic> json) =>
      MachineReminder.fromJson(json);

  @override
  List<Object?> get props => [
        machineReminderId,
        matricola,
        machine,
        reminderId,
        reminder,
      ];
}
