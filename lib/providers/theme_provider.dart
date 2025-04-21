import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('isDark');

    if (saved != null) {
      state = saved ? ThemeMode.dark : ThemeMode.light;
    } else {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      state = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = (state == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool('isDark', state == ThemeMode.dark);
  }
}
