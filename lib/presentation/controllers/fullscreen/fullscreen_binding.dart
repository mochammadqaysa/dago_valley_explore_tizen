import 'package:get/get.dart';
import 'fullscreen_controller.dart';

class FullscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FullscreenController>(() => FullscreenController());
  }
}
