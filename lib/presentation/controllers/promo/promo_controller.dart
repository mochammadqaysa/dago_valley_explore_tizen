import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:get/get.dart';

class PromoController extends GetxController {
  PromoController();

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list promo
  final _promos = RxList<Promo>([]);
  List<Promo> get promos => _promos;

  // Current promo
  Promo get currentPromo {
    if (_promos.isEmpty) {
      return dummyPromos.first;
    }
    return _promos[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadPromos();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadPromos() {
    final cachedPromos = _storage.promos;
    if (cachedPromos != null && cachedPromos.isNotEmpty) {
      print('✅ Using cached promos: ${cachedPromos.length} items');
      _promos.assignAll(cachedPromos);
    } else {
      print('⚠️ Using dummy promos');
      _promos.assignAll(dummyPromos);
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
      'Booking promo: ${currentPromo.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
