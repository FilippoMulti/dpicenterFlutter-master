// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_item_note.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SampleItemNoteCWProxy {
  SampleItemNote json(dynamic json);

  SampleItemNote reminderConfiguration(
      ReminderConfiguration? reminderConfiguration);

  SampleItemNote reminderConfigurationId(int? reminderConfigurationId);

  SampleItemNote sampleItemConfigurationId(int? sampleItemConfigurationId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItemNote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemNote(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItemNote call({
    dynamic? json,
    ReminderConfiguration? reminderConfiguration,
    int? reminderConfigurationId,
    int? sampleItemConfigurationId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSampleItemNote.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSampleItemNote.copyWith.fieldName(...)`
class _$SampleItemNoteCWProxyImpl implements _$SampleItemNoteCWProxy {
  final SampleItemNote _value;

  const _$SampleItemNoteCWProxyImpl(this._value);

  @override
  SampleItemNote json(dynamic json) => this(json: json);

  @override
  SampleItemNote reminderConfiguration(
          ReminderConfiguration? reminderConfiguration) =>
      this(reminderConfiguration: reminderConfiguration);

  @override
  SampleItemNote reminderConfigurationId(int? reminderConfigurationId) =>
      this(reminderConfigurationId: reminderConfigurationId);

  @override
  SampleItemNote sampleItemConfigurationId(int? sampleItemConfigurationId) =>
      this(sampleItemConfigurationId: sampleItemConfigurationId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SampleItemNote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemNote(...).copyWith(id: 12, name: "My name")
  /// ````
  SampleItemNote call({
    Object? json = const $CopyWithPlaceholder(),
    Object? reminderConfiguration = const $CopyWithPlaceholder(),
    Object? reminderConfigurationId = const $CopyWithPlaceholder(),
    Object? sampleItemConfigurationId = const $CopyWithPlaceholder(),
  }) {
    return SampleItemNote(
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
      sampleItemConfigurationId:
          sampleItemConfigurationId == const $CopyWithPlaceholder()
              ? _value.sampleItemConfigurationId
              // ignore: cast_nullable_to_non_nullable
              : sampleItemConfigurationId as int?,
    );
  }
}

extension $SampleItemNoteCopyWith on SampleItemNote {
  /// Returns a callable class that can be used as follows: `instanceOfSampleItemNote.copyWith(...)` or like so:`instanceOfSampleItemNote.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SampleItemNoteCWProxy get copyWith => _$SampleItemNoteCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `SampleItemNote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SampleItemNote(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  SampleItemNote copyWithNull({
    bool reminderConfiguration = false,
    bool reminderConfigurationId = false,
    bool sampleItemConfigurationId = false,
  }) {
    return SampleItemNote(
      json: json,
      reminderConfiguration:
          reminderConfiguration == true ? null : this.reminderConfiguration,
      reminderConfigurationId:
          reminderConfigurationId == true ? null : this.reminderConfigurationId,
      sampleItemConfigurationId: sampleItemConfigurationId == true
          ? null
          : this.sampleItemConfigurationId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SampleItemNote _$SampleItemNoteFromJson(Map<String, dynamic> json) =>
    SampleItemNote(
      reminderConfiguration: json['reminderConfiguration'] == null
          ? null
          : ReminderConfiguration.fromJson(
              json['reminderConfiguration'] as Map<String, dynamic>),
      sampleItemConfigurationId: json['sampleItemConfigurationId'] as int?,
      reminderConfigurationId: json['reminderConfigurationId'] as int?,
    );

Map<String, dynamic> _$SampleItemNoteToJson(SampleItemNote instance) =>
    <String, dynamic>{
      'sampleItemConfigurationId': instance.sampleItemConfigurationId,
      'reminderConfigurationId': instance.reminderConfigurationId,
      'reminderConfiguration': instance.reminderConfiguration,
    };
