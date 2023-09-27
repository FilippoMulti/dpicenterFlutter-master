// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'importa_anagrafica_clienti_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImportaAnagraficaClientiResponseCWProxy {
  ImportaAnagraficaClientiResponse info(String info);

  ImportaAnagraficaClientiResponse json(dynamic json);

  ImportaAnagraficaClientiResponse result(bool result);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImportaAnagraficaClientiResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImportaAnagraficaClientiResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ImportaAnagraficaClientiResponse call({
    String? info,
    dynamic? json,
    bool? result,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfImportaAnagraficaClientiResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfImportaAnagraficaClientiResponse.copyWith.fieldName(...)`
class _$ImportaAnagraficaClientiResponseCWProxyImpl
    implements _$ImportaAnagraficaClientiResponseCWProxy {
  final ImportaAnagraficaClientiResponse _value;

  const _$ImportaAnagraficaClientiResponseCWProxyImpl(this._value);

  @override
  ImportaAnagraficaClientiResponse info(String info) => this(info: info);

  @override
  ImportaAnagraficaClientiResponse json(dynamic json) => this(json: json);

  @override
  ImportaAnagraficaClientiResponse result(bool result) => this(result: result);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImportaAnagraficaClientiResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImportaAnagraficaClientiResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ImportaAnagraficaClientiResponse call({
    Object? info = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
  }) {
    return ImportaAnagraficaClientiResponse(
      info: info == const $CopyWithPlaceholder() || info == null
          ? _value.info
          // ignore: cast_nullable_to_non_nullable
          : info as String,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      result: result == const $CopyWithPlaceholder() || result == null
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as bool,
    );
  }
}

extension $ImportaAnagraficaClientiResponseCopyWith
    on ImportaAnagraficaClientiResponse {
  /// Returns a callable class that can be used as follows: `instanceOfImportaAnagraficaClientiResponse.copyWith(...)` or like so:`instanceOfImportaAnagraficaClientiResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ImportaAnagraficaClientiResponseCWProxy get copyWith =>
      _$ImportaAnagraficaClientiResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportaAnagraficaClientiResponse _$ImportaAnagraficaClientiResponseFromJson(
        Map<String, dynamic> json) =>
    ImportaAnagraficaClientiResponse(
      result: json['result'] as bool,
      info: json['info'] as String,
    );

Map<String, dynamic> _$ImportaAnagraficaClientiResponseToJson(
        ImportaAnagraficaClientiResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'info': instance.info,
    };
