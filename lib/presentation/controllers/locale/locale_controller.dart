import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  // Observable untuk current locale
  final _currentLocale = Rx<Locale>(Locale('id', 'ID')); // Default: Indonesian
  Locale get currentLocale => _currentLocale.value;

  // Check if current language is English
  bool get isEnglish => _currentLocale.value.languageCode == 'en';

  // Check if current language is Indonesian
  bool get isIndonesian => _currentLocale.value.languageCode == 'id';

  @override
  void onInit() {
    super.onInit();
    print('LocaleController initialized');
    // Load saved locale preference (optional)
    // _loadLocalePreference();
  }

  @override
  void onClose() {
    print('LocaleController disposed');
    super.onClose();
  }

  // Change to specific locale
  void changeLocale(String languageCode, String countryCode) {
    final locale = Locale(languageCode, countryCode);
    _currentLocale.value = locale;
    Get.updateLocale(locale);

    // Save preference (optional)
    // _saveLocalePreference(languageCode, countryCode);

    Get.snackbar(
      'language_changed'.tr,
      'language_changed_to'.trParams({'lang': _getLanguageName()}),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Toggle between Indonesian and English
  void toggleLocale() {
    if (isIndonesian) {
      changeLocale('en', 'US');
    } else {
      changeLocale('id', 'ID');
    }
  }

  // Get current language name
  String _getLanguageName() {
    switch (_currentLocale.value.languageCode) {
      case 'id':
        return 'Bahasa Indonesia';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }

  // Get current language display
  String get currentLanguageName => _getLanguageName();

  // Get current language code for display
  String get currentLanguageCode =>
      _currentLocale.value.languageCode.toUpperCase();

  // Optional: Save locale preference to storage
  // Future<void> _saveLocalePreference(String languageCode, String countryCode) async {
  //   final storage = Get.find<LocalStorageService>();
  //   await storage.setString('languageCode', languageCode);
  //   await storage.setString('countryCode', countryCode);
  // }

  // Optional: Load locale preference from storage
  // Future<void> _loadLocalePreference() async {
  //   final storage = Get.find<LocalStorageService>();
  //   final languageCode = storage.getString('languageCode') ?? 'id';
  //   final countryCode = storage.getString('countryCode') ?? 'ID';
  //   _currentLocale.value = Locale(languageCode, countryCode);
  //   Get.updateLocale(_currentLocale.value);
  // }
}
