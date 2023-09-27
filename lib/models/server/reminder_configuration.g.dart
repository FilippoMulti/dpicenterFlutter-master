// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_configuration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReminderConfigurationCWProxy {
  ReminderConfiguration alignmentX(double alignmentX);

  ReminderConfiguration alignmentY(double alignmentY);

  ReminderConfiguration backgroundColor(int? backgroundColor);

  ReminderConfiguration blink(bool blink);

  ReminderConfiguration fontSize(double fontSize);

  ReminderConfiguration fontWeight(int fontWeight);

  ReminderConfiguration freeForm(bool freeForm);

  ReminderConfiguration json(dynamic json);

  ReminderConfiguration reminderConfigurationId(int reminderConfigurationId);

  ReminderConfiguration text(String text);

  ReminderConfiguration textColor(int textColor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReminderConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReminderConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  ReminderConfiguration call({
    double? alignmentX,
    double? alignmentY,
    int? backgroundColor,
    bool? blink,
    double? fontSize,
    int? fontWeight,
    bool? freeForm,
    dynamic? json,
    int? reminderConfigurationId,
    String? text,
    int? textColor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReminderConfiguration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReminderConfiguration.copyWith.fieldName(...)`
class _$ReminderConfigurationCWProxyImpl
    implements _$ReminderConfigurationCWProxy {
  final ReminderConfiguration _value;

  const _$ReminderConfigurationCWProxyImpl(this._value);

  @override
  ReminderConfiguration alignmentX(double alignmentX) =>
      this(alignmentX: alignmentX);

  @override
  ReminderConfiguration alignmentY(double alignmentY) =>
      this(alignmentY: alignmentY);

  @override
  ReminderConfiguration backgroundColor(int? backgroundColor) =>
      this(backgroundColor: backgroundColor);

  @override
  ReminderConfiguration blink(bool blink) => this(blink: blink);

  @override
  ReminderConfiguration fontSize(double fontSize) => this(fontSize: fontSize);

  @override
  ReminderConfiguration fontWeight(int fontWeight) =>
      this(fontWeight: fontWeight);

  @override
  ReminderConfiguration freeForm(bool freeForm) => this(freeForm: freeForm);

  @override
  ReminderConfiguration json(dynamic json) => this(json: json);

  @override
  ReminderConfiguration reminderConfigurationId(int reminderConfigurationId) =>
      this(reminderConfigurationId: reminderConfigurationId);

  @override
  ReminderConfiguration text(String text) => this(text: text);

  @override
  ReminderConfiguration textColor(int textColor) => this(textColor: textColor);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReminderConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReminderConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  ReminderConfiguration call({
    Object? alignmentX = const $CopyWithPlaceholder(),
    Object? alignmentY = const $CopyWithPlaceholder(),
    Object? backgroundColor = const $CopyWithPlaceholder(),
    Object? blink = const $CopyWithPlaceholder(),
    Object? fontSize = const $CopyWithPlaceholder(),
    Object? fontWeight = const $CopyWithPlaceholder(),
    Object? freeForm = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? reminderConfigurationId = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? textColor = const $CopyWithPlaceholder(),
  }) {
    return ReminderConfiguration(
      alignmentX:
          alignmentX == const $CopyWithPlaceholder() || alignmentX == null
              ? _value.alignmentX
              // ignore: cast_nullable_to_non_nullable
              : alignmentX as double,
      alignmentY:
          alignmentY == const $CopyWithPlaceholder() || alignmentY == null
              ? _value.alignmentY
              // ignore: cast_nullable_to_non_nullable
              : alignmentY as double,
      backgroundColor: backgroundColor == const $CopyWithPlaceholder()
          ? _value.backgroundColor
          // ignore: cast_nullable_to_non_nullable
          : backgroundColor as int?,
      blink: blink == const $CopyWithPlaceholder() || blink == null
          ? _value.blink
          // ignore: cast_nullable_to_non_nullable
          : blink as bool,
      fontSize: fontSize == const $CopyWithPlaceholder() || fontSize == null
          ? _value.fontSize
          // ignore: cast_nullable_to_non_nullable
          : fontSize as double,
      fontWeight:
          fontWeight == const $CopyWithPlaceholder() || fontWeight == null
              ? _value.fontWeight
              // ignore: cast_nullable_to_non_nullable
              : fontWeight as int,
      freeForm: freeForm == const $CopyWithPlaceholder() || freeForm == null
          ? _value.freeForm
          // ignore: cast_nullable_to_non_nullable
          : freeForm as bool,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      reminderConfigurationId:
          reminderConfigurationId == const $CopyWithPlaceholder() ||
                  reminderConfigurationId == null
              ? _value.reminderConfigurationId
              // ignore: cast_nullable_to_non_nullable
              : reminderConfigurationId as int,
      text: text == const $CopyWithPlaceholder() || text == null
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      textColor: textColor == const $CopyWithPlaceholder() || textColor == null
          ? _value.textColor
          // ignore: cast_nullable_to_non_nullable
          : textColor as int,
    );
  }
}

extension $ReminderConfigurationCopyWith on ReminderConfiguration {
  /// Returns a callable class that can be used as follows: `instanceOfReminderConfiguration.copyWith(...)` or like so:`instanceOfReminderConfiguration.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReminderConfigurationCWProxy get copyWith =>
      _$ReminderConfigurationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderConfiguration _$ReminderConfigurationFromJson(
        Map<String, dynamic> json) =>
    ReminderConfiguration(
      text: json['text'] as String,
      reminderConfigurationId: json['reminderConfigurationId'] as int,
      textColor: json['textColor'] as int? ?? 0,
      backgroundColor: json['backgroundColor'] as int?,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16,
      fontWeight: json['fontWeight'] as int? ?? 1,
      alignmentX: (json['alignmentX'] as num?)?.toDouble() ?? -1.0,
      alignmentY: (json['alignmentY'] as num?)?.toDouble() ?? -1.0,
      blink: json['blink'] as bool? ?? false,
      freeForm: json['freeForm'] as bool? ?? false,
    );

Map<String, dynamic> _$ReminderConfigurationToJson(
        ReminderConfiguration instance) =>
    <String, dynamic>{
      'reminderConfigurationId': instance.reminderConfigurationId,
      'textColor': instance.textColor,
      'backgroundColor': instance.backgroundColor,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'text': instance.text,
      'alignmentX': instance.alignmentX,
      'alignmentY': instance.alignmentY,
      'blink': instance.blink,
      'freeForm': instance.freeForm,
    };
