import 'package:dago_valley_explore/presentation/controllers/sidebar/sidebar_controller.dart';
import 'package:get/get.dart';

class SidebarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SidebarController(), permanent: true);
  }
}
