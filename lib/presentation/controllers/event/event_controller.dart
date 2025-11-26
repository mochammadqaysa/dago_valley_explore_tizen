import 'package:carousel_slider/carousel_controller.dart' as cs;
import 'package:dago_valley_explore/app/services/local_storage.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/presentation/pages/event/event_gallery/event_gallery_page.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  EventController();

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  // Carousel controller
  final carouselController = cs.CarouselSliderController();

  // Observable untuk index aktif
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Observable untuk list events
  final _events = RxList<Event>([]);
  List<Event> get events => _events;

  // Current event
  Event get currentEvent {
    if (_events.isEmpty) {
      throw Exception('No events available');
    }
    return _events[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadEvents() {
    final cachedEvents = _storage.events;
    if (cachedEvents != null && cachedEvents.isNotEmpty) {
      print('✅ Using cached events: ${cachedEvents.length} items');
      _events.assignAll(cachedEvents);
    } else {
      print('⚠️ No events available, using empty list');
      _events.clear();
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
  void bookEvent() {
    Get.snackbar(
      'Booking',
      'Booking event: ${currentEvent.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Open gallery page
  void openGallery() {
    Get.to(
      () => EventGalleryPage(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Close modal
  void closeModal() {
    Get.back();
  }
}
