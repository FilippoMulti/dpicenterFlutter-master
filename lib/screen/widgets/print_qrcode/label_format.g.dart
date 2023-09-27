// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_format.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LabelFormatCWProxy {
  LabelFormat json(dynamic json);

  LabelFormat labelHeight(double labelHeight);

  LabelFormat labelWidth(double labelWidth);

  LabelFormat pageFormat(PdfPageFormat? pageFormat);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LabelFormat(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LabelFormat(...).copyWith(id: 12, name: "My name")
  /// ````
  LabelFormat call({
    dynamic? json,
    double? labelHeight,
    double? labelWidth,
    PdfPageFormat? pageFormat,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLabelFormat.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLabelFormat.copyWith.fieldName(...)`
class _$LabelFormatCWProxyImpl implements _$LabelFormatCWProxy {
  final LabelFormat _value;

  const _$LabelFormatCWProxyImpl(this._value);

  @override
  LabelFormat json(dynamic json) => this(json: json);

  @override
  LabelFormat labelHeight(double labelHeight) => this(labelHeight: labelHeight);

  @override
  LabelFormat labelWidth(double labelWidth) => this(labelWidth: labelWidth);

  @override
  LabelFormat pageFormat(PdfPageFormat? pageFormat) =>
      this(pageFormat: pageFormat);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LabelFormat(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LabelFormat(...).copyWith(id: 12, name: "My name")
  /// ````
  LabelFormat call({
    Object? json = const $CopyWithPlaceholder(),
    Object? labelHeight = const $CopyWithPlaceholder(),
    Object? labelWidth = const $CopyWithPlaceholder(),
    Object? pageFormat = const $CopyWithPlaceholder(),
  }) {
    return LabelFormat(
      json: json == const $CopyWithPlaceholder() || json == null
          ? _value.json
          // ignore: cast_nullable_to_non_nullable
          : json as dynamic,
      labelHeight:
          labelHeight == const $CopyWithPlaceholder() || labelHeight == null
              ? _value.labelHeight
              // ignore: cast_nullable_to_non_nullable
              : labelHeight as double,
      labelWidth:
          labelWidth == const $CopyWithPlaceholder() || labelWidth == null
              ? _value.labelWidth
              // ignore: cast_nullable_to_non_nullable
              : labelWidth as double,
      pageFormat: pageFormat == const $CopyWithPlaceholder()
          ? _value.pageFormat
          // ignore: cast_nullable_to_non_nullable
          : pageFormat as PdfPageFormat?,
    );
  }
}

extension $LabelFormatCopyWith on LabelFormat {
  /// Returns a callable class that can be used as follows: `instanceOfLabelFormat.copyWith(...)` or like so:`instanceOfLabelFormat.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LabelFormatCWProxy get copyWith => _$LabelFormatCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelFormat _$LabelFormatFromJson(Map<String, dynamic> json) => LabelFormat(
      labelWidth: (json['labelWidth'] as num?)?.toDouble() ?? 10.5,
      labelHeight: (json['labelHeight'] as num?)?.toDouble() ?? 14,
    );

Map<String, dynamic> _$LabelFormatToJson(LabelFormat instance) =>
    <String, dynamic>{
      'labelWidth': instance.labelWidth,
      'labelHeight': instance.labelHeight,
    };
