import 'dart:io';
import 'dart:ui';

import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/promo/promo_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:get/get.dart';

class PromoDetailPage extends GetView<PromoController> {
  const PromoDetailPage({Key? key}) : super(key: key);

  Future<File?> _localFile(String imageUrl) {
    final storage = Get.find<LocalStorageService>();
    return storage.getLocalImage(imageUrl);
  }

  Widget _buildPromoImage(
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

        // fallback ke network jika URL http(s)
        // if (imageUrl.isNotEmpty &&
        //     (imageUrl.startsWith('http://') ||
        //         imageUrl.startsWith('https://'))) {
        //   return Image.network(
        //     imageUrl,
        //     fit: fit,
        //     width: width,
        //     height: height,
        //     loadingBuilder: (context, child, progress) {
        //       if (progress == null) return child;
        //       return Container(
        //         width: width,
        //         height: height,
        //         color: Colors.grey[200],
        //         child: const Center(child: CircularProgressIndicator()),
        //       );
        //     },
        //     errorBuilder: (context, error, stackTrace) {
        //       return Container(
        //         width: width,
        //         height: height,
        //         color: Colors.grey[200],
        //         child: const Center(child: Icon(Icons.broken_image)),
        //       );
        //     },
        //   );
        // }

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
    final localeController = Get.find<LocaleController>();
    return GetX<PromoController>(
      init: controller,
      initState: (state) {
        // Init jika diperlukan
      },
      builder: (_) {
        if (controller.promos.isEmpty) {
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
                    child: _buildPromoImage(
                      controller.currentPromo.imageUrl,
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
                                          child: cs.CarouselSlider.builder(
                                            carouselController:
                                                controller.carouselController,
                                            itemCount: controller.promos.length,
                                            options: cs.CarouselOptions(
                                              height: 800,
                                              viewportFraction: 1.0,
                                              enlargeCenterPage: false,
                                              autoPlay: false,
                                              enableInfiniteScroll: false,
                                              onPageChanged: (index, reason) {
                                                controller.setCurrentIndex(
                                                  index,
                                                );
                                              },
                                            ),
                                            itemBuilder: (context, index, realIndex) {
                                              final promo =
                                                  controller.promos[index];
                                              return Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  // gunakan _buildPromoImage untuk menampilkan image (lokal/network/asset)
                                                  _buildPromoImage(
                                                    promo.imageUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  // Gradient overlay (kosongkan atau isi jika perlu)
                                                  // Container(
                                                  //   decoration:
                                                  //       const BoxDecoration(
                                                  //         gradient:
                                                  //             LinearGradient(
                                                  //               begin: Alignment
                                                  //                   .topCenter,
                                                  //               end: Alignment
                                                  //                   .bottomCenter,
                                                  //               colors: [],
                                                  //             ),
                                                  //       ),
                                                  // ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 40),

                                // Right Side - Content
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(30),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // HANYA TEKS & BUTTON YANG BERUBAH
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Container(
                                                key: ValueKey(
                                                  controller.currentIndex,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      localeController
                                                              .isIndonesian
                                                          ? controller
                                                                .currentPromo
                                                                .title
                                                          : controller
                                                                .currentPromo
                                                                .en
                                                                .title,
                                                      style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      localeController
                                                              .isIndonesian
                                                          ? controller
                                                                .currentPromo
                                                                .subtitle
                                                          : controller
                                                                .currentPromo
                                                                .en
                                                                .subtitle,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 24),
                                                    Text(
                                                      localeController
                                                              .isIndonesian
                                                          ? controller
                                                                .currentPromo
                                                                .description
                                                          : controller
                                                                .currentPromo
                                                                .en
                                                                .description,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 50),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 30),

                                            // Thumbnail navigation
                                            SizedBox(
                                              height: 180,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    controller.promos.length,
                                                itemBuilder: (context, index) {
                                                  final isActive =
                                                      index ==
                                                      controller.currentIndex;
                                                  final promo =
                                                      controller.promos[index];
                                                  return GestureDetector(
                                                    onTap: () => controller
                                                        .goToPage(index),
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      width: 120,
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        border: Border.all(
                                                          color: isActive
                                                              ? Colors.white
                                                              : Colors
                                                                    .transparent,
                                                          width: 3,
                                                        ),
                                                        boxShadow: isActive
                                                            ? [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                                  blurRadius:
                                                                      10,
                                                                  spreadRadius:
                                                                      2,
                                                                ),
                                                              ]
                                                            : null,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: Opacity(
                                                          opacity: isActive
                                                              ? 1.0
                                                              : 0.5,
                                                          child: SizedBox(
                                                            width: 120,
                                                            height: 180,
                                                            child:
                                                                _buildPromoImage(
                                                                  promo
                                                                      .imageUrl,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 180,
                                                                  width: 120,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
