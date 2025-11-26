import 'package:dago_valley_explore/presentation/controllers/siteplan/detailsiteplan/detail_siteplan_controller.dart';
import 'package:get/get.dart';

class DetailSiteplanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSiteplanController>(() => DetailSiteplanController());
  }
}
