import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QRCodeController extends GetxController {
  // use a mutable field so we can set via constructor/binding
  String _searchUrl;

  QRCodeController([String? initialUrl])
    : _searchUrl = initialUrl ?? 'https://share.google/X2hw1barxPYD8QBjy';

  String get searchUrl => _searchUrl;

  // Observable untuk loading state (jika diperlukan)
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    print('QRCodeController initialized with url=$_searchUrl');
  }

  @override
  void onClose() {
    print('QRCodeController disposed');
    super.onClose();
  }

  // Close modal
  void closeModal() {
    Get.back();
  }

  // Copy link to clipboard
  Future<void> copyLink() async {
    try {
      await Clipboard.setData(ClipboardData(text: _searchUrl));
      Get.snackbar(
        'Link Copied',
        'Link berhasil disalin ke clipboard',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyalin link: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Handle download QR (opsional)
  void downloadQR() {
    Get.snackbar(
      'Download QR',
      'QR Code berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Tambahkan logic download di sini
  }

  // Handle share QR (opsional)
  void shareQR() {
    Get.snackbar(
      'Share QR',
      'Sharing QR Code...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Tambahkan logic share di sini
  }
}
