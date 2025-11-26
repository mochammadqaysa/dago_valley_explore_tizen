import 'package:dago_valley_explore/presentation/controllers/panoramic/panoramic_controller.dart';
import 'package:get/get.dart';

class PanoramicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PanoramicController>(() => PanoramicController());
  }
}
