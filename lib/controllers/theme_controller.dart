// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart'; // To access AppTheme

class ThemeController extends GetxController {
  Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;
  Rx<bool> _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  final String _key = 'isDarkMode';
  GetStorage storage = GetStorage();

  @override
  void onInit() {
    loadTheme();
    super.onInit();
  }

  void toggleTheme(bool isDark) {
    _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    _isDarkMode.value = isDark;
    storage.write(_key, isDark);
    Get.changeTheme(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  void loadTheme() {
    bool isDark = storage.read<bool>(_key) ?? false;
    _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    Get.changeTheme(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
    _isDarkMode.value = isDark;
  }
}
