// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_configuration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UsageConfigurationCWProxy {
  UsageConfiguration json(dynamic json);

  UsageConfiguration priority(int priority);

  UsageConfiguration value(double value);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UsageConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UsageConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  UsageConfiguration call({
    dynamic? json,
    int? priority,
    double? value,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUsageConfiguration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUsageConfiguration.copyWith.fieldName(...)`
class _$UsageConfigurationCWProxyImpl implements _$UsageConfigurationCWProxy {
  final UsageConfiguration _value;

  const _$UsageConfigurationCWProxyImpl(this._value);

  @override
  UsageConfiguration json(dynamic json) => this(json: json);

  @override
  UsageConfiguration priority(int priority) => this(priority: priority);

  @override
  UsageConfiguration value(double value) => this(value: value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UsageConfiguration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UsageConfiguration(...).copyWith(id: 12, name: "My name")
  /// ````
  UsageConfiguration call({
    Object? json = const $CopyWithPlaceholder(),
    Object? priority = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return UsageConfiguration(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      priority: priority == const $CopyWithPlaceholder() || priority == null
          ? _value.priority
          // ignore: cast_nullable_to_non_nullable
          : priority as int,
      value: value == const $CopyWithPlaceholder() || value == null
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as double,
    );
  }
}

extension $UsageConfigurationCopyWith on UsageConfiguration {
  /// Returns a callable class that can be used as follows: `instanceOfUsageConfiguration.copyWith(...)` or like so:`instanceOfUsageConfiguration.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UsageConfigurationCWProxy get copyWith =>
      _$UsageConfigurationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsageConfiguration _$UsageConfigurationFromJson(Map<String, dynamic> json) =>
    UsageConfiguration(
      value: (json['value'] as num).toDouble(),
      priority: json['priority'] as int? ?? 1,
    );

Map<String, dynamic> _$UsageConfigurationToJson(UsageConfiguration instance) =>
    <String, dynamic>{
      'value': instance.value,
      'priority': instance.priority,
    };
