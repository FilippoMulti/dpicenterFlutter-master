import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/resource_response.dart';
import 'package:dpicenter/theme_manager/background_shape.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vitality/models/ItemBehaviour.dart';

part 'theme_color.g.dart';

@JsonSerializable()
@CopyWith()
class ThemeColor implements Equatable {
  final ThemeColors colorType;
  final int? customColor;
  final int backgroundImageIndex;
  final String backgroundImageName;
  final ResourceResponse? backgroundImage;
  final bool backgroundImageVisible;
  final double backgroundOpacity;
  final double backgroundBlurSigmaX;
  final double backgroundBlurSigmaY;
  final BlendMode? backgroundBlendMode;
  final ThemeFilterColors? backgroundFilterColors;
  final int? backgroundCustomFilterColor;
  final bool backgroundShowBackground;
  final bool backgroundShowEffects;
  final List<BackgroundShape>? backgroundSelectedIcons;
  final bool backgroundEnableXMovements;
  final bool backgroundEnableYMovements;
  final double backgroundMinSpeed;
  final double backgroundMaxSize;
  final double backgroundMaxSpeed;
  final List<int>? backgroundEffectsColors;
  final int menuType;

  const ThemeColor({
    required this.colorType,
    this.customColor,
    this.backgroundImageIndex = 0,
    this.backgroundImageName = 'default.webp',
    this.backgroundImageVisible = true,
    this.backgroundOpacity = 0.87,
    this.backgroundBlurSigmaX = 50,
    this.backgroundBlurSigmaY = 50,
    this.backgroundBlendMode,
    this.backgroundFilterColors,
    this.backgroundCustomFilterColor,
    this.backgroundImage,
    this.backgroundShowEffects = false,
    this.backgroundShowBackground = true,
    this.backgroundSelectedIcons,
    this.backgroundEnableXMovements = true,
    this.backgroundEnableYMovements = false,
    this.backgroundMaxSize = 30,
    this.backgroundMaxSpeed = 1.0,
    this.backgroundMinSpeed = 0.5,
    this.backgroundEffectsColors,
    this.menuType = 0,

    ///0 Standard con TabBar, 1 Mini senza TabBar (solo Desktop)
  });

  factory ThemeColor.fromJson(Map<String, dynamic> json) {
    var result = _$ThemeColorFromJson(json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ThemeColorToJson(this);

  static ThemeColor fromJsonModel(Map<String, dynamic> json) =>
      ThemeColor.fromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [
        colorType,
        customColor,
        backgroundImageIndex,
        backgroundImageName,
        backgroundImage,
        backgroundImageVisible,
        backgroundOpacity,
        backgroundBlurSigmaX,
        backgroundBlurSigmaY,
        backgroundBlendMode,
        backgroundFilterColors,
        backgroundCustomFilterColor,
        backgroundShowBackground,
        backgroundShowEffects,
        backgroundSelectedIcons,
        backgroundEnableXMovements,
        backgroundEnableYMovements,
        backgroundMaxSize,
        backgroundMaxSpeed,
        backgroundMinSpeed,
        backgroundEffectsColors,
        menuType,
      ];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

enum ThemeColors {
  green,

  ///-> default
  blue,
  red,
  custom,
}

/// Describes which theme will be used by [MaterialApp].
enum ThemeFilterColors {
  system,
  custom,
  transparent,
}
