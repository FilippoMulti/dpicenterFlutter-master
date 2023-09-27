// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QueryModelCWProxy {
  QueryModel compareType(int compareType);

  QueryModel downloadContent(bool downloadContent);

  QueryModel fieldName(String fieldName);

  QueryModel id(String id);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueryModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryModel(...).copyWith(id: 12, name: "My name")
  /// ````
  QueryModel call({
    int? compareType,
    bool? downloadContent,
    String? fieldName,
    String? id,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQueryModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQueryModel.copyWith.fieldName(...)`
class _$QueryModelCWProxyImpl implements _$QueryModelCWProxy {
  final QueryModel _value;

  const _$QueryModelCWProxyImpl(this._value);

  @override
  QueryModel compareType(int compareType) => this(compareType: compareType);

  @override
  QueryModel downloadContent(bool downloadContent) =>
      this(downloadContent: downloadContent);

  @override
  QueryModel fieldName(String fieldName) => this(fieldName: fieldName);

  @override
  QueryModel id(String id) => this(id: id);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueryModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryModel(...).copyWith(id: 12, name: "My name")
  /// ````
  QueryModel call({
    Object? compareType = const $CopyWithPlaceholder(),
    Object? downloadContent = const $CopyWithPlaceholder(),
    Object? fieldName = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
  }) {
    return QueryModel(
      compareType:
          compareType == const $CopyWithPlaceholder() || compareType == null
              ? _value.compareType
              // ignore: cast_nullable_to_non_nullable
              : compareType as int,
      downloadContent: downloadContent == const $CopyWithPlaceholder() ||
              downloadContent == null
          ? _value.downloadContent
          // ignore: cast_nullable_to_non_nullable
          : downloadContent as bool,
      fieldName: fieldName == const $CopyWithPlaceholder() || fieldName == null
          ? _value.fieldName
          // ignore: cast_nullable_to_non_nullable
          : fieldName as String,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
    );
  }
}

extension $QueryModelCopyWith on QueryModel {
  /// Returns a callable class that can be used as follows: `instanceOfQueryModel.copyWith(...)` or like so:`instanceOfQueryModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QueryModelCWProxy get copyWith => _$QueryModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryModel _$QueryModelFromJson(Map<String, dynamic> json) => QueryModel(
      id: json['id'] as String? ?? "",
      downloadContent: json['downloadContent'] as bool? ?? true,
      fieldName: json['fieldName'] as String? ?? "",
      compareType: json['compareType'] as int? ?? 0,
    );

Map<String, dynamic> _$QueryModelToJson(QueryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'downloadContent': instance.downloadContent,
      'fieldName': instance.fieldName,
      'compareType': instance.compareType,
    };
