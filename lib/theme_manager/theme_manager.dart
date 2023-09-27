import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyManager implements IThemeModeManager {
  static const _key = 'theme_mode';
  static const _color = 'theme_color_class';

  @override
  Future<Map<String?, String?>> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    return {prefs.getString(_key): prefs.getString(_color)};
  }

  @override
  Future<bool> saveThemeMode(String value, String color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, value);
    prefs.setString(_color, color);
    return true;
  }
}
