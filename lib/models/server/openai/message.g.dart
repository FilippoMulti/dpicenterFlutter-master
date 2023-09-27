// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MessageCWProxy {
  Message content(String? content);

  Message json(dynamic json);

  Message role(String? role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Message(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Message(...).copyWith(id: 12, name: "My name")
  /// ````
  Message call({
    String? content,
    dynamic? json,
    String? role,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMessage.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMessage.copyWith.fieldName(...)`
class _$MessageCWProxyImpl implements _$MessageCWProxy {
  final Message _value;

  const _$MessageCWProxyImpl(this._value);

  @override
  Message content(String? content) => this(content: content);

  @override
  Message json(dynamic json) => this(json: json);

  @override
  Message role(String? role) => this(role: role);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Message(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Message(...).copyWith(id: 12, name: "My name")
  /// ````
  Message call({
    Object? content = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return Message(
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String?,
    );
  }
}

extension $MessageCopyWith on Message {
  /// Returns a callable class that can be used as follows: `instanceOfMessage.copyWith(...)` or like so:`instanceOfMessage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessageCWProxy get copyWith => _$MessageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      role: json['role'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };
