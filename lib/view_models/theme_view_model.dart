import 'package:fave_films_2/res/theme/theme_config.dart';
import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeData _themeData = ThemeConfig.darkTheme();

  ThemeData get themeData => _themeData;

  bool _isDark = true;

  bool get isDark => _isDark;

  void setTheme(ThemeData theme, bool isDark) {
    _isDark = isDark;
    _themeData = theme;
    notifyListeners();
  }
}
