import 'dart:io';
import 'dart:ui';

import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:get/get.dart';

class PanoramicPage extends GetView<DetailSiteplanController> {
  const PanoramicPage({Key? key}) : super(key: key);

  Future<File?> _localFile(String imageUrl) {
    final storage = Get.find<LocalStorageService>();
    return storage.getLocalImage(imageUrl);
  }

  Widget _buildSiteplanImage(
    String imageUrl, {
    BoxFit fit = BoxFit.cover,
    double? height,
    double? width,
  }) {
    // gunakan FutureBuilder untuk mengecek apakah file tersedia di lokal
    return FutureBuilder<File?>(
      future: _localFile(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final file = snapshot.data;
        if (file != null && file.existsSync()) {
          return Image.file(file, fit: fit, width: width, height: height);
        }

        // terakhir, anggap sebagai asset path
        if (imageUrl.isNotEmpty) {
          return Image.asset(
            imageUrl,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.broken_image)),
              );
            },
          );
        }

        // jika tidak ada imageUrl
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.image_not_supported)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<DetailSiteplanController>(
      init: controller,
      initState: (state) {
        // Init jika diperlukan
      },
      builder: (_) {
        if (controller.firstSiteplan.isNull) {
          return const Scaffold(
            backgroundColor: Colors.black87,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return WillPopScope(
          onWillPop: () async {
            controller.closeModal();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: Stack(
              children: [
                // Background blur effect (background image)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: _buildSiteplanImage(
                      controller.firstSiteplan.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // dark overlay
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.8)),
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
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left Side - Carousel
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Main Carousel
                                      Container(
                                        height: 800,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              // gunakan _buildPromoImage untuk menampilkan image (lokal/network/asset)
                                              _buildSiteplanImage(
                                                controller
                                                    .firstSiteplan
                                                    .imageUrl,
                                                fit: BoxFit.contain,
                                              ),
                                              // Gradient overlay (kosongkan atau isi jika perlu)
                                              Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 40),
                              ],
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
}
