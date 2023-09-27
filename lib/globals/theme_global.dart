import 'dart:math';

import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/material.dart';

final MaterialStateProperty<double>? scrollBarThickness =
    isWindows || isWindowsBrowser ? MaterialStateProperty.all(15) : null;

bool isSystemDarkMode(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode;
}

bool isLightTheme(context) {
  return getCurrentCalcThemeMode(context) == ThemeMode.light;
}

bool isDarkTheme(context) {
  return getCurrentCalcThemeMode(context) == ThemeMode.dark;
}

ThemeMode getCurrentCalcThemeMode(BuildContext context) {
  switch (ThemeModeHandler.of(context)!.themeMode) {
    case ThemeMode.system:
      if (isSystemDarkMode(context)) {
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }

    default:
      return ThemeModeHandler.of(context)!.themeMode;
  }
}

ThemeColor getCurrentCalcThemeColor(BuildContext context) {
  return ThemeModeHandler.of(context)!.themeColor;
}

Color getBackgroundColor(BuildContext context) {
  return isDarkTheme(context)
      ? Color.alphaBlend(Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary)
      : Theme.of(context).colorScheme.surface;

/*  switch (ThemeModeHandler.of(context)!.themeMode) {
    case ThemeMode.system:
      if (isSystemDarkMode(context)) {
        backColor = Colors.black.withAlpha(180);
      } else {
        backColor = Colors.grey.withAlpha(100);
      }
      break;
    case ThemeMode.light:
      backColor = Colors.grey.withAlpha(100);
      break;
    case ThemeMode.dark:
      backColor = Colors.black.withAlpha(180);
      break;
    default:
      backColor = Colors.grey.withAlpha(15);
      break;
  }*/

  //return backColor;
}

Color getThemeColor(BuildContext context, ThemeColor themeColor) {
  switch (themeColor.colorType) {
    case ThemeColors.green:
      return Colors.green;
    case ThemeColors.blue:
      return Colors.blue;
    case ThemeColors.red:
      return Colors.red;
    case ThemeColors.custom:
      return themeColor.customColor != null
          ? Color(themeColor.customColor!)
          : Colors.amber;
  }
}

ThemeData? getThisLightTheme(BuildContext context, ThemeMode themeMode,
    ThemeColor themeColor, TextTheme textTheme) {
  return getLightTheme(context, themeColor, textTheme);
}

ThemeData? getThisDarkTheme(BuildContext context, ThemeMode themeMode,
    ThemeColor themeColor, TextTheme textTheme) {
  return getDarkTheme(context, themeColor, textTheme);
}

ThemeData getLightTheme(
    BuildContext context, ThemeColor color, TextTheme textTheme) {
  Color value = getThemeColor(context, color);
  MaterialColor? colorMaterial;
  if (value is MaterialColor) {
    colorMaterial = value;
  }
  ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: textTheme,
      //bottomAppBarTheme: const BottomAppBarTheme(color: Colors.red),
      //textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      scrollbarTheme: Theme.of(context)
          .scrollbarTheme
          .copyWith(thickness: scrollBarThickness),

/*      scrollbarTheme: isWindows
          ? const ScrollbarThemeData()
              .copyWith(thickness: MaterialStateProperty.all(20))
          : null,*/
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).textTheme.bodySmall!.color!))),
      /* light theme settings */
      primarySwatch: colorMaterial,
      colorSchemeSeed: colorMaterial == null && color.customColor != null
          ? Color(color.customColor!)
          : null,
      iconTheme: IconThemeData(
        color: colorMaterial ?? Color(color.customColor!),
      ));

  ///verde multi-tech
  if (color.colorType == ThemeColors.green) {
    themeData = themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(primary: kGreenMultiTech),
        primaryColor: kGreenMultiTech);
  }
  return themeData;
}

ThemeData getDarkTheme(
    BuildContext context, ThemeColor color, TextTheme textTheme) {
  Color value = getThemeColor(context, color);
  MaterialColor? colorMaterial;
  if (value is MaterialColor) {
    colorMaterial = value;
  }

  var themeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: textTheme,
      //textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      scrollbarTheme: Theme.of(context)
        .scrollbarTheme
        .copyWith(thickness: scrollBarThickness),

    inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    primarySwatch: colorMaterial,
    colorSchemeSeed: colorMaterial == null && color.customColor != null
        ? Color(color.customColor!)
        : null,
    iconTheme: IconThemeData(color: colorMaterial ?? Color(color.customColor!)),

    /*elevatedButtonTheme:
           ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(side:
                  BorderSide(color:
                  (colorMaterial == null && color.customColor != null
                      ? Color(color.customColor!)
                      : colorMaterial!)
                      ,
                      width: 1))
                ),*/
  );
  /* dark theme settings */

  themeData = themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
          primary: color.colorType == ThemeColors.green
              ? kGreenMultiTech /*Verde Multi-Tech*/
              : null,
          secondary: Color.alphaBlend(
              themeData.colorScheme.inversePrimary.withAlpha(240),
              themeData.colorScheme.primary)),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return Color.alphaBlend(
                themeData.colorScheme.primary.withAlpha(240),
                themeData.colorScheme.inversePrimary);
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return Color.alphaBlend(
                themeData.colorScheme.primary.withAlpha(240),
                themeData.colorScheme.inversePrimary);
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return Color.alphaBlend(
                themeData.colorScheme.primary.withAlpha(240),
                themeData.colorScheme.inversePrimary);
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return Color.alphaBlend(
                themeData.colorScheme.primary.withAlpha(240),
                themeData.colorScheme.inversePrimary);
          }
          return null;
        }),
      ));
  /*themeData = themeData.copyWith(
inputDecorationTheme: themeData.inputDecorationTheme.copyWith(),
      backgroundColor: Color.alphaBlend(const Color(0xFF202020).withAlpha(210), themeData.colorScheme.primary),
      canvasColor: Color.alphaBlend(const Color(0xFF202020).withAlpha(210), themeData.colorScheme.primary),
      dialogBackgroundColor: Color.alphaBlend(themeData.colorScheme.surface.withAlpha(240), themeData.colorScheme.primary),
      scaffoldBackgroundColor:
           Color.alphaBlend(const Color(0xFF252525).withAlpha(240), themeData.colorScheme.primary),
      colorScheme: themeData.colorScheme.copyWith(

        background: Color.alphaBlend(themeData.colorScheme.background.withAlpha(240), themeData.colorScheme.primary),
        surface: Color.alphaBlend(themeData.colorScheme.surface.withAlpha(240), themeData.colorScheme.primary)),);*/

  return themeData;
}

ThemeData getMaterialDarkTheme(
    BuildContext context, ThemeColor color, TextTheme textTheme) {
  Color value = getThemeColor(context, color);
  MaterialColor? colorMaterial;
  if (value is MaterialColor) {
    colorMaterial = value;
  }

  var themeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: textTheme,
      //textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      primarySwatch: colorMaterial,
      colorSchemeSeed:
          color.customColor != null ? Color(color.customColor!) : null,
      iconTheme:
          IconThemeData(color: colorMaterial ?? Color(color.customColor!))
      /* dark theme settings */
      );

  themeData = themeData.copyWith(
    canvasColor: Color.alphaBlend(themeData.colorScheme.surface.withAlpha(240),
        themeData.colorScheme.primary),
    dialogBackgroundColor: Color.alphaBlend(
        themeData.colorScheme.surface.withAlpha(240),
        themeData.colorScheme.primary),
    scaffoldBackgroundColor: Color.alphaBlend(
        themeData.scaffoldBackgroundColor.withAlpha(240),
        themeData.colorScheme.primary),
    colorScheme: themeData.colorScheme
        .copyWith(
            background: Color.alphaBlend(
                themeData.colorScheme.background.withAlpha(240),
                themeData.colorScheme.primary),
            surface: Color.alphaBlend(
                themeData.colorScheme.surface.withAlpha(240),
                themeData.colorScheme.primary))
        .copyWith(
            background: Color.alphaBlend(
                themeData.scaffoldBackgroundColor.withAlpha(240),
                themeData.colorScheme.primary)),
  );

  return themeData;
}

double computeColorDistance(Color c1, Color c2) {
  int rmean = ((c1.red + c2.red) / 2).round();
  int r = c1.red - c2.red;
  int g = c1.green - c2.green;
  int b = c1.blue - c2.blue;

  return sqrt((((512 + rmean) * r * r) >> 8) +
      4 * g * g +
      (((767 - rmean) * b * b) >> 8));
}

double computeColorDistance2(Color c1, Color c2) {
  int diffRed = (c1.red - c2.red).abs();
  int diffGreen = (c1.green - c2.green).abs();
  int diffBlue = (c1.blue - c2.blue).abs();

  double pctDiffRed = diffRed / 255;
  double pctDiffGreen = diffGreen / 255;
  double pctDiffBlue = diffBlue / 255;

  double perc = (pctDiffRed + pctDiffGreen + pctDiffBlue) / 3 * 100;

  return perc;
}

/*
typedef struct {
unsigned char r, g, b;
} RGB;

double ColourDistance(RGB e1, RGB e2)
{
  long rmean = ( (long)e1.r + (long)e2.r ) / 2;
long r = (long)e1.r - (long)e2.r;
  long g = (long)e1.g - (long)e2.g;
long b = (long)e1.b - (long)e2.b;
return sqrt((((512+rmean)*r*r)>>8) + 4*g*g + (((767-rmean)*b*b)>>8));
}*/
Color invert(String? color) {
  if (color != null) {
    Color colorValue = Color(int.parse(color));
    final r = 255 - colorValue.red;
    final g = 255 - colorValue.green;
    final b = 255 - colorValue.blue;

    return Color.fromARGB((colorValue.opacity * 255).round(), r, g, b);
  }
  return Colors.white;
}