import 'dart:io' as io;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';
import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_binding.dart';
import 'package:dago_valley_explore/presentation/pages/siteplan/detail_siteplan/detail_siteplan_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ Enum untuk tab types
enum SiteplanTabType {
  map,
  fasum,
  timelineProgress,
  siteplanStatus,
  kawasan360;

  String get label {
    switch (this) {
      case SiteplanTabType.map:
        return 'Map';
      case SiteplanTabType.fasum:
        return 'Fasum';
      case SiteplanTabType.timelineProgress:
        return 'Timeline Progress';
      case SiteplanTabType.siteplanStatus:
        return 'Siteplan Status';
      case SiteplanTabType.kawasan360:
        return 'Kawasan 360';
    }
  }

  IconData get icon {
    switch (this) {
      case SiteplanTabType.map:
        return Icons.map;
      case SiteplanTabType.fasum:
        return Icons.location_city;
      case SiteplanTabType.timelineProgress:
        return Icons.timeline;
      case SiteplanTabType.siteplanStatus:
        return Icons.assignment;
      case SiteplanTabType.kawasan360:
        return Icons.threesixty;
    }
  }
}

class SiteplanController extends GetxController {
  SiteplanController();
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  // ✅ Tab state
  final _selectedTab = Rx<SiteplanTabType>(SiteplanTabType.map);
  SiteplanTabType get selectedTab => _selectedTab.value;

  // Panorama state
  final _panoId = 0.obs;
  int get panoId => _panoId.value;

  final _lon = 0.0.obs;
  double get lon => _lon.value;

  final _lat = 0.0.obs;
  double get lat => _lat.value;

  final _tilt = 0.0.obs;
  double get tilt => _tilt.value;

  final _showDebugInfo = false.obs;
  bool get showDebugInfo => _showDebugInfo.value;

  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list siteplan
  final _siteplans = RxList<SitePlan>([]);
  List<SitePlan> get siteplans => _siteplans;
  SitePlan get firstSiteplan => _siteplans.first;

  // Panorama assets
  final panoAssets = <Image>[
    Image.asset('assets/panorama1.webp', fit: BoxFit.cover),
    Image.asset('assets/panorama2.webp', fit: BoxFit.cover),
    Image.asset('assets/panorama3.webp', fit: BoxFit.cover),
  ];

  // Get current panorama asset
  Image get currentPanoAsset => panoAssets[_panoId.value % panoAssets.length];

  // Check if running on desktop
  bool get isDesktop {
    return !kIsWeb &&
        (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS);
  }

  void loadSiteplans() {
    final cachedSiteplans = _storage.siteplans;
    if (cachedSiteplans != null && cachedSiteplans.isNotEmpty) {
      print('✅ Using cached siteplan: ${cachedSiteplans.length} items');
      _siteplans.assignAll(cachedSiteplans);
    } else {
      print('⚠️ Using dummy siteplan');
      // _siteplans.assignAll(dummyPromos);
    }
  }

  SitePlan get currentSiteplan {
    if (_siteplans.isEmpty) {
      return _siteplans.first;
    }
    return _siteplans[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    _initializePanorama();
    loadSiteplans();
  }

  void _initializePanorama() {
    if (kDebugMode) {
      print('Initializing Siteplan Panorama');
    }
  }

  // ✅ Change selected tab
  void setSelectedTab(SiteplanTabType tab) {
    _selectedTab.value = tab;
    if (kDebugMode) {
      print('Tab changed to: ${tab.label}');
    }
  }

  // Update panorama view
  void onViewChanged(double longitude, double latitude, double tilt) {
    _lon.value = longitude;
    _lat.value = latitude;
    _tilt.value = tilt;
  }

  // Handle panorama tap
  void onPanoramaTap(double longitude, double latitude, double tilt) {
    if (kDebugMode) {
      print('onTap: $longitude, $latitude, $tilt');
    }
  }

  // Go to next panorama
  void goToNextPanorama() {
    _panoId.value = (_panoId.value + 1) % panoAssets.length;
    if (kDebugMode) {
      print('Switched to panorama: ${_panoId.value}');
    }
  }

  // Go to previous panorama
  void goToPreviousPanorama() {
    _panoId.value = (_panoId.value - 1 + panoAssets.length) % panoAssets.length;
    if (kDebugMode) {
      print('Switched to panorama: ${_panoId.value}');
    }
  }

  // Toggle debug info
  void toggleDebugInfo() {
    _showDebugInfo.value = !_showDebugInfo.value;
  }

  // Show notify snackbar
  void showNotifySnack() {
    Get.snackbar(
      'Terima Kasih',
      'Kami akan memberi tahu Anda saat fitur Siteplan tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  // Get brochure URL from storage
  String? getBrochureUrl() {
    try {
      final brochures = _storage.brochures;
      if (kDebugMode) {
        print('Fetched brochures from local storage: $brochures');
      }
      if (brochures != null && brochures.isNotEmpty) {
        final first = brochures.first;
        return first.imageUrl?.toString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching brochures from local storage: $e');
      }
    }
    return null;
  }

  // Show siteplan modal
  void showSitePlanModal([String? url]) {
    if (url == null || url.isEmpty) {
      url = getBrochureUrl();
    }

    if (url == null || url.isEmpty) {
      Get.snackbar(
        'Site Plan',
        'Tidak ada URL brochure yang tersedia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (kDebugMode) {
      print('Opening Siteplan detail modal with url: $url');
    }

    Get.to(
      () => const SiteplanDetailPage(),
      binding: DetailSiteplanBinding(),
      arguments: url,
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  // Get sensor control based on platform
  dynamic get sensorControl {
    return isDesktop ? 'none' : 'orientation';
  }
}
