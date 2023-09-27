// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_validation_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KeyValidationStateCWProxy {
  KeyValidationState key(GlobalKey<State<StatefulWidget>> key);

  KeyValidationState state(bool? state);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KeyValidationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyValidationState(...).copyWith(id: 12, name: "My name")
  /// ````
  KeyValidationState call({
    GlobalKey<State<StatefulWidget>>? key,
    bool? state,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKeyValidationState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKeyValidationState.copyWith.fieldName(...)`
class _$KeyValidationStateCWProxyImpl implements _$KeyValidationStateCWProxy {
  final KeyValidationState _value;

  const _$KeyValidationStateCWProxyImpl(this._value);

  @override
  KeyValidationState key(GlobalKey<State<StatefulWidget>> key) =>
      this(key: key);

  @override
  KeyValidationState state(bool? state) => this(state: state);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KeyValidationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyValidationState(...).copyWith(id: 12, name: "My name")
  /// ````
  KeyValidationState call({
    Object? key = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
  }) {
    return KeyValidationState(
      key: key == const $CopyWithPlaceholder() || key == null
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as GlobalKey<State<StatefulWidget>>,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as bool?,
    );
  }
}

extension $KeyValidationStateCopyWith on KeyValidationState {
  /// Returns a callable class that can be used as follows: `instanceOfKeyValidationState.copyWith(...)` or like so:`instanceOfKeyValidationState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$KeyValidationStateCWProxy get copyWith =>
      _$KeyValidationStateCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `KeyValidationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KeyValidationState(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  KeyValidationState copyWithNull({
    bool state = false,
  }) {
    return KeyValidationState(
      key: key,
      state: state == true ? null : this.state,
    );
  }
}
