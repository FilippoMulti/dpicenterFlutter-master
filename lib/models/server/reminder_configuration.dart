import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'reminder_configuration.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ReminderConfiguration extends Equatable implements JsonPayload {
  final int reminderConfigurationId;

  final int textColor;
  final int? backgroundColor;
  final double fontSize;
  final int fontWeight;
  final String text;

  ///allineamento del testo
  final double alignmentX;
  final double alignmentY;

  final bool blink;

  ///forma libera non vincolata da minWidth e minHeight
  final bool freeForm;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const ReminderConfiguration({
    required this.text,
    required this.reminderConfigurationId,
    this.textColor = 0,
    this.backgroundColor,
    this.fontSize = 16,
    this.fontWeight = 1,
    this.alignmentX = -1.0,
    this.alignmentY = -1.0,
    this.blink = false,
    this.freeForm = false,
    this.json,
  });

  factory ReminderConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$ReminderConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ReminderConfigurationToJson(this);

  static ReminderConfiguration fromJsonModel(Map<String, dynamic> json) =>
      ReminderConfiguration.fromJson(json);

  @override
  List<Object?> get props => [
        reminderConfigurationId,
        textColor,
        backgroundColor,
        fontSize,
        fontWeight,
        alignmentX,
        alignmentY,
        text,
        blink,
        freeForm,
      ];
}
