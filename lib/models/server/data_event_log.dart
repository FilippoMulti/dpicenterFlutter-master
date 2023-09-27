import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'event_type_enum.dart';

part 'data_event_log.g.dart';

@JsonSerializable()
@CopyWith()
class DataEventLog extends Equatable implements JsonPayload {
  final int? eventId;
  final String? date;
  final String? controller;
  final int? applicationUserId;
  final String? eventString;
  final EventTypeEnum? eventType;
  final String? jsonObject;
  final String? userAgent;
  final String? origin;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const DataEventLog({
    this.eventId,
    this.date,
    this.controller,
    this.applicationUserId,
    this.eventString,
    this.eventType,
    this.jsonObject,
    this.userAgent,
    this.origin,
    this.json,
  });

  factory DataEventLog.fromJson(Map<String, dynamic> json) {
    var result = _$DataEventLogFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$DataEventLogToJson(this);

  static DataEventLog fromJsonModel(Map<String, dynamic> json) =>
      DataEventLog.fromJson(json);

  @override
  List<Object?> get props => [
        eventId,
        date,
        controller,
        applicationUserId,
        eventString,
        eventType,
        userAgent,
        origin,
        jsonObject
      ];
}
