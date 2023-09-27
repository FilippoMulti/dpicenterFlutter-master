// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_attachment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IssueAttachmentCWProxy {
  IssueAttachment content(String? content);

  IssueAttachment json(dynamic json);

  IssueAttachment name(String? name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IssueAttachment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IssueAttachment(...).copyWith(id: 12, name: "My name")
  /// ````
  IssueAttachment call({
    String? content,
    dynamic? json,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIssueAttachment.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIssueAttachment.copyWith.fieldName(...)`
class _$IssueAttachmentCWProxyImpl implements _$IssueAttachmentCWProxy {
  final IssueAttachment _value;

  const _$IssueAttachmentCWProxyImpl(this._value);

  @override
  IssueAttachment content(String? content) => this(content: content);

  @override
  IssueAttachment json(dynamic json) => this(json: json);

  @override
  IssueAttachment name(String? name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IssueAttachment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IssueAttachment(...).copyWith(id: 12, name: "My name")
  /// ````
  IssueAttachment call({
    Object? content = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return IssueAttachment(
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $IssueAttachmentCopyWith on IssueAttachment {
  /// Returns a callable class that can be used as follows: `instanceOfIssueAttachment.copyWith(...)` or like so:`instanceOfIssueAttachment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IssueAttachmentCWProxy get copyWith => _$IssueAttachmentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueAttachment _$IssueAttachmentFromJson(Map<String, dynamic> json) =>
    IssueAttachment(
      name: json['name'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$IssueAttachmentToJson(IssueAttachment instance) =>
    <String, dynamic>{
      'name': instance.name,
      'content': instance.content,
    };
