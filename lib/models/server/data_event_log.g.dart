// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_event_log.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataEventLogCWProxy {
  DataEventLog applicationUserId(int? applicationUserId);

  DataEventLog controller(String? controller);

  DataEventLog date(String? date);

  DataEventLog eventId(int? eventId);

  DataEventLog eventString(String? eventString);

  DataEventLog eventType(EventTypeEnum? eventType);

  DataEventLog json(dynamic json);

  DataEventLog jsonObject(String? jsonObject);

  DataEventLog origin(String? origin);

  DataEventLog userAgent(String? userAgent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataEventLog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataEventLog(...).copyWith(id: 12, name: "My name")
  /// ````
  DataEventLog call({
    int? applicationUserId,
    String? controller,
    String? date,
    int? eventId,
    String? eventString,
    EventTypeEnum? eventType,
    dynamic? json,
    String? jsonObject,
    String? origin,
    String? userAgent,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDataEventLog.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDataEventLog.copyWith.fieldName(...)`
class _$DataEventLogCWProxyImpl implements _$DataEventLogCWProxy {
  final DataEventLog _value;

  const _$DataEventLogCWProxyImpl(this._value);

  @override
  DataEventLog applicationUserId(int? applicationUserId) =>
      this(applicationUserId: applicationUserId);

  @override
  DataEventLog controller(String? controller) => this(controller: controller);

  @override
  DataEventLog date(String? date) => this(date: date);

  @override
  DataEventLog eventId(int? eventId) => this(eventId: eventId);

  @override
  DataEventLog eventString(String? eventString) =>
      this(eventString: eventString);

  @override
  DataEventLog eventType(EventTypeEnum? eventType) =>
      this(eventType: eventType);

  @override
  DataEventLog json(dynamic json) => this(json: json);

  @override
  DataEventLog jsonObject(String? jsonObject) => this(jsonObject: jsonObject);

  @override
  DataEventLog origin(String? origin) => this(origin: origin);

  @override
  DataEventLog userAgent(String? userAgent) => this(userAgent: userAgent);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataEventLog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataEventLog(...).copyWith(id: 12, name: "My name")
  /// ````
  DataEventLog call({
    Object? applicationUserId = const $CopyWithPlaceholder(),
    Object? controller = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? eventId = const $CopyWithPlaceholder(),
    Object? eventString = const $CopyWithPlaceholder(),
    Object? eventType = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? jsonObject = const $CopyWithPlaceholder(),
    Object? origin = const $CopyWithPlaceholder(),
    Object? userAgent = const $CopyWithPlaceholder(),
  }) {
    return DataEventLog(
      applicationUserId: applicationUserId == const $CopyWithPlaceholder()
          ? _value.applicationUserId
          // ignore: cast_nullable_to_non_nullable
          : applicationUserId as int?,
      controller: controller == const $CopyWithPlaceholder()
          ? _value.controller
          // ignore: cast_nullable_to_non_nullable
          : controller as String?,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String?,
      eventId: eventId == const $CopyWithPlaceholder()
          ? _value.eventId
          // ignore: cast_nullable_to_non_nullable
          : eventId as int?,
      eventString: eventString == const $CopyWithPlaceholder()
          ? _value.eventString
          // ignore: cast_nullable_to_non_nullable
          : eventString as String?,
      eventType: eventType == const $CopyWithPlaceholder()
          ? _value.eventType
          // ignore: cast_nullable_to_non_nullable
          : eventType as EventTypeEnum?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      jsonObject: jsonObject == const $CopyWithPlaceholder()
          ? _value.jsonObject
          // ignore: cast_nullable_to_non_nullable
          : jsonObject as String?,
      origin: origin == const $CopyWithPlaceholder()
          ? _value.origin
          // ignore: cast_nullable_to_non_nullable
          : origin as String?,
      userAgent: userAgent == const $CopyWithPlaceholder()
          ? _value.userAgent
          // ignore: cast_nullable_to_non_nullable
          : userAgent as String?,
    );
  }
}

extension $DataEventLogCopyWith on DataEventLog {
  /// Returns a callable class that can be used as follows: `instanceOfDataEventLog.copyWith(...)` or like so:`instanceOfDataEventLog.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DataEventLogCWProxy get copyWith => _$DataEventLogCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataEventLog _$DataEventLogFromJson(Map<String, dynamic> json) => DataEventLog(
      eventId: json['eventId'] as int?,
      date: json['date'] as String?,
      controller: json['controller'] as String?,
      applicationUserId: json['applicationUserId'] as int?,
      eventString: json['eventString'] as String?,
      eventType: $enumDecodeNullable(_$EventTypeEnumEnumMap, json['eventType']),
      jsonObject: json['jsonObject'] as String?,
      userAgent: json['userAgent'] as String?,
      origin: json['origin'] as String?,
    );

Map<String, dynamic> _$DataEventLogToJson(DataEventLog instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'date': instance.date,
      'controller': instance.controller,
      'applicationUserId': instance.applicationUserId,
      'eventString': instance.eventString,
      'eventType': _$EventTypeEnumEnumMap[instance.eventType],
      'jsonObject': instance.jsonObject,
      'userAgent': instance.userAgent,
      'origin': instance.origin,
    };

const _$EventTypeEnumEnumMap = {
  EventTypeEnum.add: 0,
  EventTypeEnum.update: 1,
  EventTypeEnum.delete: 2,
  EventTypeEnum.other: 3,
};
