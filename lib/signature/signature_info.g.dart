// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SignatureInfoCWProxy {
  SignatureInfo contactPerson(String? contactPerson);

  SignatureInfo pointList(MultiPointList? pointList);

  SignatureInfo signature(Uint8List? signature);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SignatureInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SignatureInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  SignatureInfo call({
    String? contactPerson,
    MultiPointList? pointList,
    Uint8List? signature,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSignatureInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSignatureInfo.copyWith.fieldName(...)`
class _$SignatureInfoCWProxyImpl implements _$SignatureInfoCWProxy {
  final SignatureInfo _value;

  const _$SignatureInfoCWProxyImpl(this._value);

  @override
  SignatureInfo contactPerson(String? contactPerson) =>
      this(contactPerson: contactPerson);

  @override
  SignatureInfo pointList(MultiPointList? pointList) =>
      this(pointList: pointList);

  @override
  SignatureInfo signature(Uint8List? signature) => this(signature: signature);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SignatureInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SignatureInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  SignatureInfo call({
    Object? contactPerson = const $CopyWithPlaceholder(),
    Object? pointList = const $CopyWithPlaceholder(),
    Object? signature = const $CopyWithPlaceholder(),
  }) {
    return SignatureInfo(
      contactPerson: contactPerson == const $CopyWithPlaceholder()
          ? _value.contactPerson
          // ignore: cast_nullable_to_non_nullable
          : contactPerson as String?,
      pointList: pointList == const $CopyWithPlaceholder()
          ? _value.pointList
          // ignore: cast_nullable_to_non_nullable
          : pointList as MultiPointList?,
      signature: signature == const $CopyWithPlaceholder()
          ? _value.signature
          // ignore: cast_nullable_to_non_nullable
          : signature as Uint8List?,
    );
  }
}

extension $SignatureInfoCopyWith on SignatureInfo {
  /// Returns a callable class that can be used as follows: `instanceOfSignatureInfo.copyWith(...)` or like so:`instanceOfSignatureInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SignatureInfoCWProxy get copyWith => _$SignatureInfoCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `SignatureInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SignatureInfo(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  SignatureInfo copyWithNull({
    bool contactPerson = false,
    bool pointList = false,
    bool signature = false,
  }) {
    return SignatureInfo(
      contactPerson: contactPerson == true ? null : this.contactPerson,
      pointList: pointList == true ? null : this.pointList,
      signature: signature == true ? null : this.signature,
    );
  }
}
