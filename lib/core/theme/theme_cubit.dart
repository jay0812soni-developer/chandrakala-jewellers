import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'cj_theme_mode';

  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString(_key);
      if (modeStr == 'dark') {
        emit(ThemeMode.dark);
      } else if (modeStr == 'light') {
        emit(ThemeMode.light);
      } else {
        emit(ThemeMode.system);
      }
    } catch (_) {}
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, next == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : (mode == ThemeMode.light ? 'light' : 'system'));
    } catch (_) {}
  }
}
