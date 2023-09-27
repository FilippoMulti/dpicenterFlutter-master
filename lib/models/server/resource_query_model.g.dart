// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_query_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResourceQueryModelCWProxy {
  ResourceQueryModel id(int id);

  ResourceQueryModel name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResourceQueryModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResourceQueryModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ResourceQueryModel call({
    int? id,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResourceQueryModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResourceQueryModel.copyWith.fieldName(...)`
class _$ResourceQueryModelCWProxyImpl implements _$ResourceQueryModelCWProxy {
  final ResourceQueryModel _value;

  const _$ResourceQueryModelCWProxyImpl(this._value);

  @override
  ResourceQueryModel id(int id) => this(id: id);

  @override
  ResourceQueryModel name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResourceQueryModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResourceQueryModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ResourceQueryModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return ResourceQueryModel(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $ResourceQueryModelCopyWith on ResourceQueryModel {
  /// Returns a callable class that can be used as follows: `instanceOfResourceQueryModel.copyWith(...)` or like so:`instanceOfResourceQueryModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResourceQueryModelCWProxy get copyWith =>
      _$ResourceQueryModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceQueryModel _$ResourceQueryModelFromJson(Map<String, dynamic> json) =>
    ResourceQueryModel(
      name: json['name'] as String,
      id: json['id'] as int? ?? -1,
    );

Map<String, dynamic> _$ResourceQueryModelToJson(ResourceQueryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
