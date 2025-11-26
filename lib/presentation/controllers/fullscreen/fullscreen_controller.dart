import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart'; // atau fullscreen_window

class FullscreenController extends GetxController {
  // Observable untuk track fullscreen state
  final RxBool _isFullscreen = false.obs;
  bool get isFullscreen => _isFullscreen.value;

  @override
  void onInit() {
    super.onInit();
    _checkFullscreenState();
  }

  // Cek state fullscreen saat init
  Future<void> _checkFullscreenState() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        final isFullScreen = await windowManager.isFullScreen();
        _isFullscreen.value = isFullScreen;
      } catch (e) {
        if (kDebugMode) print('Error checking fullscreen state: $e');
      }
    }
  }

  // Toggle fullscreen
  Future<void> toggleFullscreen() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        final currentState = await windowManager.isFullScreen();
        await windowManager.setFullScreen(!currentState);
        _isFullscreen.value = !currentState;

        Get.snackbar(
          'Fullscreen',
          _isFullscreen.value ? 'Mode Fullscreen Aktif' : 'Mode Windowed Aktif',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        if (kDebugMode) print('Error toggling fullscreen: $e');
        Get.snackbar(
          'Error',
          'Gagal mengubah mode fullscreen',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Info',
        'Fullscreen hanya tersedia di Desktop',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Enter fullscreen
  Future<void> enterFullscreen() async {
    if (!_isFullscreen.value) {
      await toggleFullscreen();
    }
  }

  // Exit fullscreen
  Future<void> exitFullscreen() async {
    if (_isFullscreen.value) {
      await toggleFullscreen();
    }
  }
}
