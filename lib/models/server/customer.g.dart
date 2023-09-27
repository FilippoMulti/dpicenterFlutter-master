// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CustomerCWProxy {
  Customer cFiscale(String? cFiscale);

  Customer cap(String? cap);

  Customer code(String? code);

  Customer comune(String? comune);

  Customer customerId(String? customerId);

  Customer description(String? description);

  Customer indirizzo(String? indirizzo);

  Customer isManualEntry(bool? isManualEntry);

  Customer json(dynamic json);

  Customer nazione(String? nazione);

  Customer pIva(String? pIva);

  Customer provincia(String? provincia);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Customer(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Customer(...).copyWith(id: 12, name: "My name")
  /// ````
  Customer call({
    String? cFiscale,
    String? cap,
    String? code,
    String? comune,
    String? customerId,
    String? description,
    String? indirizzo,
    bool? isManualEntry,
    dynamic? json,
    String? nazione,
    String? pIva,
    String? provincia,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCustomer.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCustomer.copyWith.fieldName(...)`
class _$CustomerCWProxyImpl implements _$CustomerCWProxy {
  final Customer _value;

  const _$CustomerCWProxyImpl(this._value);

  @override
  Customer cFiscale(String? cFiscale) => this(cFiscale: cFiscale);

  @override
  Customer cap(String? cap) => this(cap: cap);

  @override
  Customer code(String? code) => this(code: code);

  @override
  Customer comune(String? comune) => this(comune: comune);

  @override
  Customer customerId(String? customerId) => this(customerId: customerId);

  @override
  Customer description(String? description) => this(description: description);

  @override
  Customer indirizzo(String? indirizzo) => this(indirizzo: indirizzo);

  @override
  Customer isManualEntry(bool? isManualEntry) =>
      this(isManualEntry: isManualEntry);

  @override
  Customer json(dynamic json) => this(json: json);

  @override
  Customer nazione(String? nazione) => this(nazione: nazione);

  @override
  Customer pIva(String? pIva) => this(pIva: pIva);

  @override
  Customer provincia(String? provincia) => this(provincia: provincia);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Customer(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Customer(...).copyWith(id: 12, name: "My name")
  /// ````
  Customer call({
    Object? cFiscale = const $CopyWithPlaceholder(),
    Object? cap = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? comune = const $CopyWithPlaceholder(),
    Object? customerId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? indirizzo = const $CopyWithPlaceholder(),
    Object? isManualEntry = const $CopyWithPlaceholder(),
    Object? json = const $CopyWithPlaceholder(),
    Object? nazione = const $CopyWithPlaceholder(),
    Object? pIva = const $CopyWithPlaceholder(),
    Object? provincia = const $CopyWithPlaceholder(),
  }) {
    return Customer(
      cFiscale: cFiscale == const $CopyWithPlaceholder()
          ? _value.cFiscale
          // ignore: cast_nullable_to_non_nullable
          : cFiscale as String?,
      cap: cap == const $CopyWithPlaceholder()
          ? _value.cap
          // ignore: cast_nullable_to_non_nullable
          : cap as String?,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String?,
      comune: comune == const $CopyWithPlaceholder()
          ? _value.comune
          // ignore: cast_nullable_to_non_nullable
          : comune as String?,
      customerId: customerId == const $CopyWithPlaceholder()
          ? _value.customerId
          // ignore: cast_nullable_to_non_nullable
          : customerId as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      indirizzo: indirizzo == const $CopyWithPlaceholder()
          ? _value.indirizzo
          // ignore: cast_nullable_to_non_nullable
          : indirizzo as String?,
      isManualEntry: isManualEntry == const $CopyWithPlaceholder()
          ? _value.isManualEntry
          // ignore: cast_nullable_to_non_nullable
          : isManualEntry as bool?,
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      nazione: nazione == const $CopyWithPlaceholder()
          ? _value.nazione
          // ignore: cast_nullable_to_non_nullable
          : nazione as String?,
      pIva: pIva == const $CopyWithPlaceholder()
          ? _value.pIva
          // ignore: cast_nullable_to_non_nullable
          : pIva as String?,
      provincia: provincia == const $CopyWithPlaceholder()
          ? _value.provincia
          // ignore: cast_nullable_to_non_nullable
          : provincia as String?,
    );
  }
}

extension $CustomerCopyWith on Customer {
  /// Returns a callable class that can be used as follows: `instanceOfCustomer.copyWith(...)` or like so:`instanceOfCustomer.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CustomerCWProxy get copyWith => _$CustomerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      customerId: json['customerId'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      pIva: json['pIva'] as String?,
      cFiscale: json['cFiscale'] as String?,
      indirizzo: json['indirizzo'] as String?,
      cap: json['cap'] as String?,
      comune: json['comune'] as String?,
      provincia: json['provincia'] as String?,
      nazione: json['nazione'] as String?,
      isManualEntry: json['isManualEntry'] as bool?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'code': instance.code,
      'description': instance.description,
      'pIva': instance.pIva,
      'cFiscale': instance.cFiscale,
      'indirizzo': instance.indirizzo,
      'cap': instance.cap,
      'comune': instance.comune,
      'provincia': instance.provincia,
      'nazione': instance.nazione,
      'isManualEntry': instance.isManualEntry,
    };
