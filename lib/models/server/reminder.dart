import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'reminder.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Reminder extends Equatable implements JsonPayload {
  final int reminderId;
  final String? date;
  final String? deadline;
  final int? reminderConfigurationId;
  final ReminderConfiguration? reminderConfiguration;
  final int? state;
  final int? applicationUserId;
  final ApplicationUser? applicationUser;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Reminder({
    required this.reminderId,
    this.reminderConfiguration,
    this.date,
    this.deadline,
    this.reminderConfigurationId,
    this.state,
    this.applicationUserId,
    this.applicationUser,
    this.json,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    var result = _$ReminderFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReminderToJson(this);

  static Reminder fromJsonModel(Map<String, dynamic> json) =>
      Reminder.fromJson(json);

  @override
  List<Object?> get props => [
        reminderId,
        reminderConfiguration,
        date,
        deadline,
        reminderConfigurationId,
        state,
        applicationUserId,
        applicationUser,
      ];
}
