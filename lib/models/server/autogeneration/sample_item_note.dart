import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sample_item_note.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class SampleItemNote extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int? sampleItemConfigurationId;
  final int? reminderConfigurationId;
  final ReminderConfiguration? reminderConfiguration;

  const SampleItemNote(
      {this.reminderConfiguration,
      this.sampleItemConfigurationId,
      this.reminderConfigurationId,
      this.json});

  factory SampleItemNote.fromJson(Map<String, dynamic> json) {
    var result = _$SampleItemNoteFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$SampleItemNoteToJson(this);

  static SampleItemNote fromJsonModel(Map<String, dynamic> json) =>
      SampleItemNote.fromJson(json);

  @override
  List<Object?> get props =>
      [
        sampleItemConfigurationId,
        reminderConfigurationId,
        reminderConfiguration,
      ];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
