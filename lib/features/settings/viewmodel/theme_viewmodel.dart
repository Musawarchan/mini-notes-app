import 'package:flutter/material.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  int _seedColorIndex = 0;

  ThemeMode get themeMode => _themeMode;
  int get seedColorIndex => _seedColorIndex;

  Future<void> init() async {
    await _loadThemeSettings();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await StorageService.setInt(AppConstants.themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setSeedColorIndex(int index) async {
    _seedColorIndex = index;
    await StorageService.setInt(AppConstants.seedColorIndexKey, index);
    notifyListeners();
  }

  Future<void> _loadThemeSettings() async {
    final themeModeIndex = StorageService.getInt(AppConstants.themeModeKey);
    final seedColorIndex =
        StorageService.getInt(AppConstants.seedColorIndexKey);

    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }

    if (seedColorIndex != null && seedColorIndex < AppTheme.seedColors.length) {
      _seedColorIndex = seedColorIndex;
    }

    notifyListeners();
  }
}
