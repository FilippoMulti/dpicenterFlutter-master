// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_frame.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocFrameCWProxy {
  DocFrame attachments(String? attachments);

  DocFrame audio(String? audio);

  DocFrame content(String? content);

  DocFrame dataframeId(int? dataframeId);

  DocFrame generate(bool generate);

  DocFrame id(int? id);

  DocFrame json(dynamic json);

  DocFrame section(String? section);

  DocFrame title(String? title);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocFrame(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocFrame(...).copyWith(id: 12, name: "My name")
  /// ````
  DocFrame call({
    String? attachments,
    String? audio,
    String? content,
    int? dataframeId,
    bool? generate,
    int? id,
    dynamic? json,
    String? section,
    String? title,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocFrame.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocFrame.copyWith.fieldName(...)`
class _$DocFrameCWProxyImpl implements _$DocFrameCWProxy {
  final DocFrame _value;

  const _$DocFrameCWProxyImpl(this._value);

  @override
  DocFrame attachments(String? attachments) => this(attachments: attachments);

  @override
  DocFrame audio(String? audio) => this(audio: audio);

  @override
  DocFrame content(String? content) => this(content: content);

  @override
  DocFrame dataframeId(int? dataframeId) => this(dataframeId: dataframeId);

  @override
  DocFrame generate(bool generate) => this(generate: generate);

  @override
  DocFrame id(int? id) => this(id: id);

  @override
  DocFrame json(dynamic json) => this(json: json);

  @override
  DocFrame section(String? section) => this(section: section);

  @override
  DocFrame title(String? title) => this(title: title);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocFrame(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocFrame(...).copyWith(id: 12, name: "My name")
  /// ````
  DocFrame call({
    Object? attachments = const $CopyWithPlaceholder(),
    Object? audio = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? dataframeId = const $CopyWithPlaceholder(),
    Object? generate = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? section = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
  }) {
    return DocFrame(
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as String?,
      audio: audio == const $CopyWithPlaceholder()
          ? _value.audio
          // ignore: cast_nullable_to_non_nullable
          : audio as String?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      dataframeId: dataframeId == const $CopyWithPlaceholder()
          ? _value.dataframeId
          // ignore: cast_nullable_to_non_nullable
          : dataframeId as int?,
      generate: generate == const $CopyWithPlaceholder() || generate == null
          ? _value.generate
          // ignore: cast_nullable_to_non_nullable
          : generate as bool,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      section: section == const $CopyWithPlaceholder()
          ? _value.section
      // ignore: cast_nullable_to_non_nullable
          : section as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
      // ignore: cast_nullable_to_non_nullable
          : title as String?,
    );
  }
}

extension $DocFrameCopyWith on DocFrame {
  /// Returns a callable class that can be used as follows: `instanceOfDocFrame.copyWith(...)` or like so:`instanceOfDocFrame.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocFrameCWProxy get copyWith => _$DocFrameCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocFrame _$DocFrameFromJson(Map<String, dynamic> json) => DocFrame(
  id: json['id'] as int?,
  dataframeId: json['dataframeId'] as int?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  section: json['section'] as String?,
  generate: json['generate'] as bool? ?? true,
  audio: json['audio'] as String?,
  attachments: json['attachments'] as String?,
    );

Map<String, dynamic> _$DocFrameToJson(DocFrame instance) => <String, dynamic>{
      'id': instance.id,
      'dataframeId': instance.dataframeId,
      'title': instance.title,
      'content': instance.content,
      'section': instance.section,
      'audio': instance.audio,
      'generate': instance.generate,
      'attachments': instance.attachments,
    };
