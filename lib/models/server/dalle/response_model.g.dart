// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResponseModelCWProxy {
  ResponseModel created(int? created);

  ResponseModel data(List<Link>? data);

  ResponseModel json(dynamic json);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResponseModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResponseModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ResponseModel call({
    int? created,
    List<Link>? data,
    dynamic? json,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResponseModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResponseModel.copyWith.fieldName(...)`
class _$ResponseModelCWProxyImpl implements _$ResponseModelCWProxy {
  final ResponseModel _value;

  const _$ResponseModelCWProxyImpl(this._value);

  @override
  ResponseModel created(int? created) => this(created: created);

  @override
  ResponseModel data(List<Link>? data) => this(data: data);

  @override
  ResponseModel json(dynamic json) => this(json: json);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResponseModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResponseModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ResponseModel call({
    Object? created = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
  }) {
    return ResponseModel(
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as int?,
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Link>?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
    );
  }
}

extension $ResponseModelCopyWith on ResponseModel {
  /// Returns a callable class that can be used as follows: `instanceOfResponseModel.copyWith(...)` or like so:`instanceOfResponseModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResponseModelCWProxy get copyWith => _$ResponseModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      created: json['created'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'created': instance.created,
      'data': instance.data,
    };
