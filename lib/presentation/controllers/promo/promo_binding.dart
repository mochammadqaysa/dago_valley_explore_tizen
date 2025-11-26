import 'package:dago_valley_explore/presentation/controllers/promo/promo_controller.dart';
import 'package:get/get.dart';

class PromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoController>(() => PromoController());
  }
}
