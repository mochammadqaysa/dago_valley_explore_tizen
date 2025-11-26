import 'dart:io';

import 'package:dago_valley_explore/app/extensions/color.dart';
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/app/types/tab_type.dart';
import 'package:dago_valley_explore/domain/repositories/house_repository.dart';
import 'package:dago_valley_explore/domain/usecases/fetch_housing_use_case.dart';
import 'package:dago_valley_explore/presentation/components/drawer/bottom_user_info.dart';
import 'package:dago_valley_explore/presentation/components/drawer/custom_list_tile.dart';
import 'package:dago_valley_explore/presentation/components/drawer/header.dart';
import 'package:dago_valley_explore/presentation/controllers/fullscreen/fullscreen_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/splash/splash_binding.dart';
import 'package:dago_valley_explore/presentation/controllers/splash/splash_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/theme/theme_controller.dart';
import 'package:dago_valley_explore/presentation/pages/splashscreen/splashscreen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomDrawer extends GetView<SidebarController> {
  const CustomDrawer({Key? key}) : super(key: key);

  void _showExitConfirmation(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: themeController.isDarkMode
            ? HexColor("1C1C19")
            : HexColor("EBEBEB"),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(Icons.warning_rounded, size: 64, color: Colors.orange),
              const SizedBox(height: 16),

              // Title
              Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: themeController.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Tombol Batal
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // Tutup dialog
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: themeController.isDarkMode
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Keluar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _exitApp(); // ✅ Exit aplikasi
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true, // Bisa ditutup dengan klik di luar dialog
    );
  }

  void _showSyncConfirmation(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: themeController.isDarkMode
            ? HexColor("1C1C19")
            : HexColor("EBEBEB"),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(Icons.sync_rounded, size: 64, color: Colors.blue),
              const SizedBox(height: 16),

              // Title
              Text(
                'Konfirmasi Sinkronisasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                'Apakah Anda yakin ingin menghapus cache dan menyinkronkan ulang data? Aplikasi akan restart.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: themeController.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Tombol Batal
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // Tutup dialog
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: themeController.isDarkMode
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Sinkronisasi
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _clearCacheAndRestart(); // ✅ Clear cache dan restart
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sinkronisasi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true, // Bisa ditutup dengan klik di luar dialog
    );
  }

  // ✅ Method untuk exit aplikasi
  void _exitApp() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Untuk Mobile
      SystemNavigator.pop();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Untuk Desktop
      exit(0);
    }
  }

  // ✅ Method untuk clear cache dan restart ke splashscreen
  // ✅ Method untuk clear cache dan restart ke splashscreen
  Future<void> _clearCacheAndRestart() async {
    try {
      // Tutup dialog konfirmasi
      Get.back();

      // Tampilkan loading indicator
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(40),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Menghapus cache dan menyinkronkan...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      print('🔄 Starting cache clear and restart...');

      // Clear cache dari LocalStorageService
      final localStorageService = Get.find<LocalStorageService>();
      await localStorageService.clearCache();

      print('✅ Cache cleared successfully');

      // Tunggu sebentar untuk memastikan cache terhapus
      await Future.delayed(const Duration(milliseconds: 500));

      // ✅ PERBAIKAN: Hapus SEMUA controller yang tidak permanent
      print('🗑️ Deleting all controllers...');

      // Hapus SidebarController
      if (Get.isRegistered<SidebarController>()) {
        Get.delete<SidebarController>(force: true);
        print('✅ SidebarController deleted');
      }

      // ✅ PENTING: Hapus SplashController juga
      if (Get.isRegistered<SplashController>()) {
        Get.delete<SplashController>(force: true);
        print('✅ SplashController deleted');
      }

      // Hapus dependency lain yang mungkin ter-register
      if (Get.isRegistered<FetchHousingDataUseCase>()) {
        Get.delete<FetchHousingDataUseCase>(force: true);
        print('✅ FetchHousingDataUseCase deleted');
      }

      if (Get.isRegistered<HouseRepository>()) {
        Get.delete<HouseRepository>(force: true);
        print('✅ HouseRepository deleted');
      }

      // Tutup drawer jika terbuka
      // if (Get.isDrawerOpen ?? false) {
      //   Get.back();
      // }

      // Tunggu sebentar
      await Future.delayed(const Duration(milliseconds: 300));

      // Tutup loading indicator
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('🚀 Navigating to SplashScreen...');

      // ✅ PERBAIKAN: Reset semua dan navigate dengan binding baru
      await Get.offAll(
        () => SplashScreen(),
        binding: SplashBinding(), // Ini akan create instance baru
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );

      print('✅ Navigation complete');
    } catch (e, stackTrace) {
      print('❌ Error clearing cache: $e');
      print('Stack trace: $stackTrace');

      // Tutup loading jika ada
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Tampilkan error
      Get.snackbar(
        'Error',
        'Gagal menghapus cache: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetX<SidebarController>(
      init: controller,
      builder: (_) {
        return SafeArea(
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
            width: controller.isCollapsed ? 300 : 95,
            margin: const EdgeInsets.only(bottom: 23, top: 23, left: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              // color: HexColor("EBEBEB"),
              // color: HexColor("1C1C19"),
              color: themeController.isDarkMode
                  ? HexColor("1C1C19")
                  : HexColor("EBEBEB"),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  CustomDrawerHeader(
                    isColapsed: controller.isCollapsed,
                    onToggle: controller.toggleCollapse,
                  ),
                  const Spacer(),
                  ...TabType.values
                      .where((e) => e != TabType.bookingonlinepage)
                      .map(
                        (e) => CustomListTile(
                          isActive: controller.isTabActive(e),
                          isCollapsed: controller.isCollapsed,
                          icon: Icons.home_max,
                          svgIcon: e.svgIcon,
                          title: e.title,
                          infoCount: 0,
                          onTap: () => controller.setActiveTab(e),
                        ),
                      )
                      .toList(),
                  const Spacer(),
                  Visibility(
                    visible: true,
                    child: CustomListTile(
                      isActive: false,
                      isCollapsed: controller.isCollapsed,
                      icon: Icons.sync,
                      svgIcon: "assets/menu/sync_icon.svg",
                      title: 'Sync Data',
                      infoCount: 0,
                      onTap: () {
                        _showSyncConfirmation(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: CustomListTile(
                      isActive: false,
                      isCollapsed: controller.isCollapsed,
                      icon: Icons.exit_to_app,
                      svgIcon: "assets/menu/power_icon.svg",
                      title: 'Exit App',
                      infoCount: 0,
                      onTap: () {
                        _showExitConfirmation(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // BottomUserInfo(isCollapsed: controller.isCollapsed),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
