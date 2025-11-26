import 'dart:io';
import 'dart:ui';
import 'package:dago_valley_explore/presentation/controllers/locale/locale_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/panoramic/panoramic_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramicPage extends GetView<PanoramicController> {
  const PanoramicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Panorama viewer
            Positioned.fill(child: _buildPanoramaViewer()),
            // Top-left close button
            Positioned(top: 12, left: 12, child: _buildCloseButton()),
            // Optional: Debug info
            if (controller.showDebugInfo)
              Positioned(bottom: 20, left: 20, child: _buildDebugInfo()),
            // Optional: Navigation controls
            Positioned(
              bottom: 20,
              right: 20,
              child: _buildNavigationControls(),
            ),
          ],
        ),
      ),
    );
  }

  // Close button
  Widget _buildCloseButton() {
    return Padding(
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
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanoramaViewer() {
    return Obx(() {
      try {
        // Get hotspots dinamis berdasarkan panorama yang aktif
        final hotspots = controller.currentHotspots
            .map(
              (hotspot) => Hotspot(
                latitude: hotspot.latitude,
                longitude: hotspot.longitude,
                width: hotspot.width,
                height: hotspot.height,
                widget: _buildHotspotWidget(hotspot),
              ),
            )
            .toList();

        return PanoramaViewer(
          animSpeed: 0.1,
          sensorControl: controller.isDesktop
              ? SensorControl.none
              : SensorControl.orientation,
          onViewChanged: controller.onViewChanged,
          onTap: controller.onPanoramaTap,
          hotspots: hotspots,
          child: controller.currentPanoAsset,
        );
      } catch (e, st) {
        debugPrint('PanoramaViewer failed: $e\n$st');
        return _buildPanoramaFallback();
      }
    });
  }

  // Build hotspot widget yang bisa diklik
  Widget _buildHotspotWidget(PanoramaHotspot hotspot) {
    return GestureDetector(
      onTap: () async {
        // Handle hotspot tap (bisa navigasi atau buka link)
        await controller.handleHotspotTap(hotspot);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          Container(
            child: Image.asset(hotspot.iconPath, width: 250, height: 250),
          ),
          const SizedBox(height: 8),
          // Label
          if (hotspot.label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hotspot.isExternalLink)
                    const Icon(
                      Icons.open_in_new,
                      color: Colors.white,
                      size: 14,
                    ),
                  if (hotspot.isExternalLink) const SizedBox(width: 4),
                  Text(
                    hotspot.label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Build panorama fallback
  Widget _buildPanoramaFallback() {
    return Obx(
      () => Stack(
        fit: StackFit.expand,
        children: [
          controller.currentPanoAsset,
          const Center(
            child: Text(
              'Panorama unavailable',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Debug info widget
  Widget _buildDebugInfo() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panorama: ${controller.panoramaData[controller.panoId].fileName}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'ID: ${controller.panoId + 1}/${controller.panoramaData.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Lon: ${controller.lon.toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Lat: ${controller.lat.toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Hotspots: ${controller.currentHotspots.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation controls
  Widget _buildNavigationControls() {
    return Column(
      children: [
        // Toggle debug button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.toggleDebugInfo,
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
                Icons.info_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Previous panorama
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.goToPreviousPanorama,
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
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Next panorama
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.goToNextPanorama,
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
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
