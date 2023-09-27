// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_shape.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackgroundShapeCWProxy {
  BackgroundShape icon(String? icon);

  BackgroundShape shape(ShapeType shape);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackgroundShape(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackgroundShape(...).copyWith(id: 12, name: "My name")
  /// ````
  BackgroundShape call({
    String? icon,
    ShapeType? shape,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBackgroundShape.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBackgroundShape.copyWith.fieldName(...)`
class _$BackgroundShapeCWProxyImpl implements _$BackgroundShapeCWProxy {
  final BackgroundShape _value;

  const _$BackgroundShapeCWProxyImpl(this._value);

  @override
  BackgroundShape icon(String? icon) => this(icon: icon);

  @override
  BackgroundShape shape(ShapeType shape) => this(shape: shape);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackgroundShape(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackgroundShape(...).copyWith(id: 12, name: "My name")
  /// ````
  BackgroundShape call({
    Object? icon = const $CopyWithPlaceholder(),
    Object? shape = const $CopyWithPlaceholder(),
  }) {
    return BackgroundShape(
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String?,
      shape: shape == const $CopyWithPlaceholder() || shape == null
          ? _value.shape
          // ignore: cast_nullable_to_non_nullable
          : shape as ShapeType,
    );
  }
}

extension $BackgroundShapeCopyWith on BackgroundShape {
  /// Returns a callable class that can be used as follows: `instanceOfBackgroundShape.copyWith(...)` or like so:`instanceOfBackgroundShape.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BackgroundShapeCWProxy get copyWith => _$BackgroundShapeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundShape _$BackgroundShapeFromJson(Map<String, dynamic> json) =>
    BackgroundShape(
      shape: $enumDecodeNullable(_$ShapeTypeEnumMap, json['shape']) ??
          ShapeType.FilledCircle,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$BackgroundShapeToJson(BackgroundShape instance) =>
    <String, dynamic>{
      'shape': _$ShapeTypeEnumMap[instance.shape]!,
      'icon': instance.icon,
    };

const _$ShapeTypeEnumMap = {
  ShapeType.FilledCircle: 'FilledCircle',
  ShapeType.StrokeCircle: 'StrokeCircle',
  ShapeType.DoubleStrokeCircle: 'DoubleStrokeCircle',
  ShapeType.TripleStrokeCircle: 'TripleStrokeCircle',
  ShapeType.FilledTriangle: 'FilledTriangle',
  ShapeType.StrokeTriangle: 'StrokeTriangle',
  ShapeType.DoubleStrokeTriangle: 'DoubleStrokeTriangle',
  ShapeType.TripleStrokeTriangle: 'TripleStrokeTriangle',
  ShapeType.Icon: 'Icon',
};
