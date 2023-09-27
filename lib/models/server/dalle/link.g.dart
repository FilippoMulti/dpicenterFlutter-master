// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LinkCWProxy {
  Link json(dynamic json);

  Link url(String? url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Link(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Link(...).copyWith(id: 12, name: "My name")
  /// ````
  Link call({
    dynamic? json,
    String? url,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLink.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLink.copyWith.fieldName(...)`
class _$LinkCWProxyImpl implements _$LinkCWProxy {
  final Link _value;

  const _$LinkCWProxyImpl(this._value);

  @override
  Link json(dynamic json) => this(json: json);

  @override
  Link url(String? url) => this(url: url);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Link(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Link(...).copyWith(id: 12, name: "My name")
  /// ````
  Link call({
    Object? json = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return Link(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $LinkCopyWith on Link {
  /// Returns a callable class that can be used as follows: `instanceOfLink.copyWith(...)` or like so:`instanceOfLink.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LinkCWProxy get copyWith => _$LinkCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
      url: json['url'] as String?,
    );

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'url': instance.url,
    };
