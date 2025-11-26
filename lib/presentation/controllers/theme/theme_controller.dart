import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable untuk dark mode
  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    print('ThemeController initialized');

    // Update system chrome whenever theme changes
    ever<bool>(_isDarkMode, (isDark) {
      _applySystemUI(isDark);
    });

    // Optional: load persisted theme preference here
    // _loadThemePreference();
  }

  @override
  void onClose() {
    print('ThemeController disposed');
    super.onClose();
  }

  // Toggle theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    // Do NOT call Get.changeThemeMode here if your GetMaterialApp is rebuilt by Obx.
    // If you prefer Get.changeThemeMode, you may use it instead of Obx at root,
    // but avoid doing both to prevent inconsistent behavior.
    // Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // Optionally persist preference here
    // _saveThemePreference();
  }

  // Apply System UI overlay (status bar icons etc.)
  void _applySystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? const Color(0xFF121212)
            : Colors.white,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  // Get current theme data
  ThemeData get currentTheme {
    return _isDarkMode.value ? darkTheme : lightTheme;
  }

  // Dark Theme
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: createMaterialColor(HexColor("636A5A")),
      scaffoldBackgroundColor: HexColor("121212"),
      cardColor: HexColor("1C1C19"),
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor("1C1C19"),
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }

  // Light Theme
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: createMaterialColor(HexColor("636A5A")),
      scaffoldBackgroundColor: HexColor("F4F4F4"),
      cardColor: HexColor("EBEBEB"),
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor("EBEBEB"),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  // Optional: persistence helpers (implement LocalStorageService usage if needed)
  // Future<void> _saveThemePreference() async { ... }
  // Future<void> _loadThemePreference() async { ... }
}
