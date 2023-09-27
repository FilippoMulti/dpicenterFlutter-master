// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResourceResponseCWProxy {
  ResourceResponse contents(String? contents);

  ResourceResponse decodedContents(Uint8List? decodedContents);

  ResourceResponse json(dynamic json);

  ResourceResponse name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResourceResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResourceResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ResourceResponse call({
    String? contents,
    Uint8List? decodedContents,
    dynamic? json,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResourceResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResourceResponse.copyWith.fieldName(...)`
class _$ResourceResponseCWProxyImpl implements _$ResourceResponseCWProxy {
  final ResourceResponse _value;

  const _$ResourceResponseCWProxyImpl(this._value);

  @override
  ResourceResponse contents(String? contents) => this(contents: contents);

  @override
  ResourceResponse decodedContents(Uint8List? decodedContents) =>
      this(decodedContents: decodedContents);

  @override
  ResourceResponse json(dynamic json) => this(json: json);

  @override
  ResourceResponse name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResourceResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResourceResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ResourceResponse call({
    Object? contents = const $CopyWithPlaceholder(),
    Object? decodedContents = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return ResourceResponse(
      contents: contents == const $CopyWithPlaceholder()
          ? _value.contents
          // ignore: cast_nullable_to_non_nullable
          : contents as String?,
      decodedContents: decodedContents == const $CopyWithPlaceholder()
          ? _value.decodedContents
          // ignore: cast_nullable_to_non_nullable
          : decodedContents as Uint8List?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $ResourceResponseCopyWith on ResourceResponse {
  /// Returns a callable class that can be used as follows: `instanceOfResourceResponse.copyWith(...)` or like so:`instanceOfResourceResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResourceResponseCWProxy get copyWith => _$ResourceResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceResponse _$ResourceResponseFromJson(Map<String, dynamic> json) =>
    ResourceResponse(
      name: json['name'] as String,
      contents: json['contents'] as String?,
    );

Map<String, dynamic> _$ResourceResponseToJson(ResourceResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contents': instance.contents,
    };
