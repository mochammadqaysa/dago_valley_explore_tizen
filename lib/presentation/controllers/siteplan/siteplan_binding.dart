import 'package:get/get.dart';
import 'siteplan_controller.dart';

class SiteplanBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchHeadlineUseCase(Get.find<ArticleRepositoryIml>()));
    Get.lazyPut<SiteplanController>(() => SiteplanController());
  }
}
