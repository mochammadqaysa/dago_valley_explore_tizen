import 'package:dago_valley_explore/presentation/controllers/event/event_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/promo/promo_controller.dart';
import 'package:get/get.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }
}
