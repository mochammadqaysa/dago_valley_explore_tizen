import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';
import 'package:get/get.dart';

class DetailSiteplanController extends GetxController {
  DetailSiteplanController();

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list siteplan
  final _siteplans = RxList<SitePlan>([]);
  List<SitePlan> get siteplans => _siteplans;
  SitePlan get firstSiteplan => _siteplans.first;

  // Current promo
  SitePlan get currentSiteplan {
    if (_siteplans.isEmpty) {
      return _siteplans.first;
    }
    return _siteplans[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadSiteplans();
  }

  @override
  void onClose() {
    super.onClose();
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

  // Set index carousel
  void setCurrentIndex(int index) {
    _currentIndex.value = index;
  }

  // Go to specific page
  void goToPage(int index) {
    carouselController.animateToPage(index);
  }

  // Handle booking action
  void bookPromo() {
    Get.snackbar(
      'Booking',
      'Booking promo: ${currentSiteplan.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
