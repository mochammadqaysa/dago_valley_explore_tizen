import 'package:get/get.dart';
import 'licenselegaldocument_controller.dart';

class LicenselegaldocumentBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut(() => LicenselegaldocumentController(Get.find()));
  }
}
