// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InputCWProxy {
  Input json(dynamic json);

  Input n(int n);

  Input prompt(String? prompt);

  Input size(String? size);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Input(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Input(...).copyWith(id: 12, name: "My name")
  /// ````
  Input call({
    dynamic? json,
    int? n,
    String? prompt,
    String? size,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInput.copyWith.fieldName(...)`
class _$InputCWProxyImpl implements _$InputCWProxy {
  final Input _value;

  const _$InputCWProxyImpl(this._value);

  @override
  Input json(dynamic json) => this(json: json);

  @override
  Input n(int n) => this(n: n);

  @override
  Input prompt(String? prompt) => this(prompt: prompt);

  @override
  Input size(String? size) => this(size: size);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Input(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Input(...).copyWith(id: 12, name: "My name")
  /// ````
  Input call({
    Object? json = const $CopyWithPlaceholder(),
    Object? n = const $CopyWithPlaceholder(),
    Object? prompt = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
  }) {
    return Input(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      n: n == const $CopyWithPlaceholder() || n == null
          ? _value.n
          // ignore: cast_nullable_to_non_nullable
          : n as int,
      prompt: prompt == const $CopyWithPlaceholder()
          ? _value.prompt
          // ignore: cast_nullable_to_non_nullable
          : prompt as String?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as String?,
    );
  }
}

extension $InputCopyWith on Input {
  /// Returns a callable class that can be used as follows: `instanceOfInput.copyWith(...)` or like so:`instanceOfInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InputCWProxy get copyWith => _$InputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Input _$InputFromJson(Map<String, dynamic> json) => Input(
      prompt: json['prompt'] as String?,
      n: json['n'] as int? ?? 1,
      size: json['size'] as String?,
    );

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
      'prompt': instance.prompt,
      'n': instance.n,
      'size': instance.size,
    };
