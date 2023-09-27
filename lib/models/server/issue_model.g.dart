// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IssueModelCWProxy {
  IssueModel issueAttachments(List<IssueAttachment>? issueAttachments);

  IssueModel json(dynamic json);

  IssueModel message(String? message);

  IssueModel title(String? title);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IssueModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IssueModel(...).copyWith(id: 12, name: "My name")
  /// ````
  IssueModel call({
    List<IssueAttachment>? issueAttachments,
    dynamic? json,
    String? message,
    String? title,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIssueModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIssueModel.copyWith.fieldName(...)`
class _$IssueModelCWProxyImpl implements _$IssueModelCWProxy {
  final IssueModel _value;

  const _$IssueModelCWProxyImpl(this._value);

  @override
  IssueModel issueAttachments(List<IssueAttachment>? issueAttachments) =>
      this(issueAttachments: issueAttachments);

  @override
  IssueModel json(dynamic json) => this(json: json);

  @override
  IssueModel message(String? message) => this(message: message);

  @override
  IssueModel title(String? title) => this(title: title);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IssueModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IssueModel(...).copyWith(id: 12, name: "My name")
  /// ````
  IssueModel call({
    Object? issueAttachments = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
  }) {
    return IssueModel(
      issueAttachments: issueAttachments == const $CopyWithPlaceholder()
          ? _value.issueAttachments
          // ignore: cast_nullable_to_non_nullable
          : issueAttachments as List<IssueAttachment>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
    );
  }
}

extension $IssueModelCopyWith on IssueModel {
  /// Returns a callable class that can be used as follows: `instanceOfIssueModel.copyWith(...)` or like so:`instanceOfIssueModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IssueModelCWProxy get copyWith => _$IssueModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueModel _$IssueModelFromJson(Map<String, dynamic> json) => IssueModel(
      title: json['title'] as String?,
      message: json['message'] as String?,
      issueAttachments: (json['issueAttachments'] as List<dynamic>?)
          ?.map((e) => IssueAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IssueModelToJson(IssueModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'issueAttachments': instance.issueAttachments,
    };
