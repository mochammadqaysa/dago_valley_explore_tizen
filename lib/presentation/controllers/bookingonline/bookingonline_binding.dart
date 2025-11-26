import 'package:get/get.dart';
import 'bookingonline_controller.dart';

class BookingonlineBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => BookingonlineController(Get.find()));
  }
}
