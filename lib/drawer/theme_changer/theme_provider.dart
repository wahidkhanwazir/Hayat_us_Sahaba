
import 'package:flutter/material.dart';

class ThemeChangerProvider with ChangeNotifier {
  var _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isLightTheme => _themeMode == ThemeMode.light;
  void setTheme(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

}