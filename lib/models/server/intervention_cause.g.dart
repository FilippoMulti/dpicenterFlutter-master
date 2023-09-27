// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_cause.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InterventionCauseCWProxy {
  InterventionCause cause(String? cause);

  InterventionCause interventionCauseId(int? interventionCauseId);

  InterventionCause json(dynamic json);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InterventionCause(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InterventionCause(...).copyWith(id: 12, name: "My name")
  /// ````
  InterventionCause call({
    String? cause,
    int? interventionCauseId,
    dynamic? json,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInterventionCause.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInterventionCause.copyWith.fieldName(...)`
class _$InterventionCauseCWProxyImpl implements _$InterventionCauseCWProxy {
  final InterventionCause _value;

  const _$InterventionCauseCWProxyImpl(this._value);

  @override
  InterventionCause cause(String? cause) => this(cause: cause);

  @override
  InterventionCause interventionCauseId(int? interventionCauseId) =>
      this(interventionCauseId: interventionCauseId);

  @override
  InterventionCause json(dynamic json) => this(json: json);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InterventionCause(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InterventionCause(...).copyWith(id: 12, name: "My name")
  /// ````
  InterventionCause call({
    Object? cause = const $CopyWithPlaceholder(),
    Object? interventionCauseId = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
  }) {
    return InterventionCause(
      cause: cause == const $CopyWithPlaceholder()
          ? _value.cause
          // ignore: cast_nullable_to_non_nullable
          : cause as String?,
      interventionCauseId: interventionCauseId == const $CopyWithPlaceholder()
          ? _value.interventionCauseId
          // ignore: cast_nullable_to_non_nullable
          : interventionCauseId as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
    );
  }
}

extension $InterventionCauseCopyWith on InterventionCause {
  /// Returns a callable class that can be used as follows: `instanceOfInterventionCause.copyWith(...)` or like so:`instanceOfInterventionCause.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InterventionCauseCWProxy get copyWith =>
      _$InterventionCauseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterventionCause _$InterventionCauseFromJson(Map<String, dynamic> json) =>
    InterventionCause(
      interventionCauseId: json['interventionCauseId'] as int?,
      cause: json['cause'] as String?,
    );

Map<String, dynamic> _$InterventionCauseToJson(InterventionCause instance) =>
    <String, dynamic>{
      'interventionCauseId': instance.interventionCauseId,
      'cause': instance.cause,
    };
