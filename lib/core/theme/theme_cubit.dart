import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _kThemeMode = 'theme_mode';

  ThemeCubit() : super(_loadInitialTheme());

  static ThemeMode _loadInitialTheme() {
    final saved = SharedPref.prefs.getString(_kThemeMode);
    if (saved == 'light') return ThemeMode.light;
    if (saved == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  void toggleTheme() {
    final ThemeMode next;
    if (state == ThemeMode.dark) {
      next = ThemeMode.light;
    } else {
      // covers both light and system
      next = ThemeMode.dark;
    }
    SharedPref.prefs.setString(_kThemeMode, next == ThemeMode.dark ? 'dark' : 'light');
    emit(next);
  }
}

