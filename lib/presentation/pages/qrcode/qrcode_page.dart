import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';

class QRCodePage extends GetView<QRCodeController> {
  const QRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QRCodeController>(
      init: controller,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            controller.closeModal();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Background blur effect
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.black.withOpacity(0.7)),
                  ),
                ),

                // Content
                SafeArea(
                  child: Column(
                    children: [
                      // Close Button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: controller.closeModal,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Main Content
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Glass Container with QR Code
                                  Container(
                                    padding: const EdgeInsets.all(40),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Logo atau Icon
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.qr_code_2,
                                                size: 40,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            const SizedBox(height: 24),

                                            // Title
                                            const Text(
                                              'Scan QR Code',
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            // Subtitle
                                            Text(
                                              'Cari "Dago Valley" di Google',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 32),

                                            // QR Code
                                            Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 10),
                                                  ),
                                                ],
                                              ),
                                              child: QrImageView(
                                                data: controller.searchUrl,
                                                version: QrVersions.auto,
                                                size: 280,
                                                backgroundColor: Colors.white,
                                                eyeStyle: const QrEyeStyle(
                                                  eyeShape: QrEyeShape.square,
                                                  color: Colors.black,
                                                ),
                                                dataModuleStyle:
                                                    const QrDataModuleStyle(
                                                      dataModuleShape:
                                                          QrDataModuleShape
                                                              .square,
                                                      color: Colors.black,
                                                    ),
                                                embeddedImage: null,
                                                embeddedImageStyle: null,
                                                errorCorrectionLevel:
                                                    QrErrorCorrectLevel.H,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                              width: 1000,
                                            ),

                                            // URL Display
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.link,
                                                    color: Colors.white70,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      controller.searchUrl,
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 32),

                                            // Action Buttons
                                            Visibility(
                                              visible: false,
                                              child: Row(
                                                children: [
                                                  // Copy Link Button
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 50,
                                                      child: ElevatedButton.icon(
                                                        onPressed: () {
                                                          Clipboard.setData(
                                                            ClipboardData(
                                                              text: controller
                                                                  .searchUrl,
                                                            ),
                                                          );
                                                          Get.snackbar(
                                                            'Link Copied',
                                                            'Link berhasil disalin ke clipboard',
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.teal,
                                                            colorText:
                                                                Colors.white,
                                                            duration:
                                                                const Duration(
                                                                  seconds: 2,
                                                                ),
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.copy,
                                                          size: 18,
                                                        ),
                                                        label: const Text(
                                                          'Copy Link',
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  25,
                                                                ),
                                                          ),
                                                          elevation: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),

                                                  // Share Button
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 50,
                                                      child: ElevatedButton.icon(
                                                        onPressed: () {
                                                          Get.snackbar(
                                                            'Share',
                                                            'Share feature coming soon',
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.blue,
                                                            colorText:
                                                                Colors.white,
                                                            duration:
                                                                const Duration(
                                                                  seconds: 2,
                                                                ),
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.share,
                                                          size: 18,
                                                        ),
                                                        label: const Text(
                                                          'Share',
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.teal,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  25,
                                                                ),
                                                          ),
                                                          elevation: 5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Instructions
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildInstructionItem(
                                          '1',
                                          'Buka aplikasi kamera atau QR scanner',
                                        ),
                                        const SizedBox(height: 12),
                                        _buildInstructionItem(
                                          '2',
                                          'Arahkan ke QR Code di atas',
                                        ),
                                        const SizedBox(height: 12),
                                        _buildInstructionItem(
                                          '3',
                                          'Otomatis akan mengakses laman resmi Dago Valley',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
