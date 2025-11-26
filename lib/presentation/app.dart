import 'package:dago_valley_explore/app/translation/app_translations.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/splash/splash_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/pages/splashscreen/splashscreen_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/home/home_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize Controllers
    final themeController = Get.put(ThemeController(), permanent: true);
    final localeController = Get.put(LocaleController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'app_name'.tr,

        // Theme configuration (use themeMode from controller)
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.themeMode,

        // Locale configuration
        locale: localeController.currentLocale,
        translations: AppTranslations(),
        fallbackLocale: Locale('id', 'ID'),

        initialRoute: "/",
        initialBinding: SplashBinding(),
        home: SplashScreen(),
      ),
    );
  }
}
