import 'dart:convert';

import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:flutter/material.dart';

/// Interface to be implemented in order
/// to load and save the selected `ThemeMode`.
abstract class IThemeModeManager {
  /// Loads the selected `ThemeMode` as a `String`.
  Future<Map<String?, String?>> loadThemeMode();

  /// Allows the consumer to save the selected `ThemeMode` as a `String`.
  Future<bool> saveThemeMode(String theme, String color);
}

/// Wrap the management of the functionality and allow the consumer
/// to persist and retrieve the user's preference wherever they want.
class ThemeModeHandler extends StatefulWidget {
  /// Function that runs when themeMode changes.
  final Widget Function(ThemeMode themeMode, ThemeColor themeColor) builder;

  /// Implementation of IThemeModeManager to load and save the selected value.
  final IThemeModeManager manager;

  /// Default value to be used when shared preference is null.
  final ThemeMode defaultTheme;

  final ThemeColor defaultThemeColor;

  /// While the themeMode is loaded, you can choose to render a different widget.
  /// By default, it'll render an empty container.
  final Widget? placeholderWidget;

  /// Creates a `ThemeModeHandler`.
  const ThemeModeHandler({
    Key? key,
    required this.builder,
    required this.manager,
    this.defaultTheme = ThemeMode.system,
    this.defaultThemeColor = const ThemeColor(colorType: ThemeColors.blue),
    this.placeholderWidget,
  }) : super(key: key);

  @override
  _ThemeModeHandlerState createState() => _ThemeModeHandlerState();

  /// Access to the closest [ThemeModeHandler] instance to the given context.
  static _ThemeModeHandlerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeModeHandlerState>();
  }
}

class _ThemeModeHandlerState extends State<ThemeModeHandler> {
  late final Future<Map<ThemeMode, ThemeColor>> _initFuture = _loadThemeMode();

  late ThemeMode _themeMode;
  late ThemeColor _themeColor;

  bool get isCustomColor => themeColor.colorType == ThemeColors.custom;

  /// Current selected value.
  ThemeMode get themeMode => _themeMode;

  ThemeColor get themeColor => _themeColor;

  /// Updates the themeMode and calls `manager.saveThemeMode`.
  Future<void> saveThemeMode(ThemeMode value, ThemeColor color) async {
    _updateThemeMode(value, color);
    await widget.manager
        .saveThemeMode(value.toString(), jsonEncode(color.toJson()));
  }

  /// Updates theme.
  Future<void> update() async {
    _update();
    /*await widget.manager
        .saveThemeMode(value.toString(), jsonEncode(color.toJson()));*/
  }

  Future<Map<ThemeMode, ThemeColor>> _loadThemeMode() async {
    final value = await widget.manager.loadThemeMode();

    final theme = ThemeMode.values.firstWhere(
      (v) => v.toString() == value.keys.first,
      orElse: () => widget.defaultTheme,
    );
    ThemeColor? color;
    if (value[value.keys.first] != null) {
      color = ThemeColor.fromJson(jsonDecode(value[value.keys.first]!));
    } else {
      color = const ThemeColor(colorType: ThemeColors.green);
    }
    _updateThemeMode(theme, color);
    return {theme: color};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<ThemeMode, ThemeColor>>(
      future: _initFuture,
      builder: (_, snapshot) {
        return snapshot.hasData
            ? widget.builder(_themeMode, _themeColor)
            : widget.placeholderWidget ?? Container();
      },
    );
  }

  void _updateThemeMode(ThemeMode value, ThemeColor color) {
    setState(() {
      _themeMode = value;
      _themeColor = color;
    });
  }

  void _update() {
    setState(() {});
  }
}
