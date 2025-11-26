import 'package:get/get.dart';
import 'virtualtour_controller.dart';

class VirtualtourBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => VirtualtourController(Get.find()));
  }
}
