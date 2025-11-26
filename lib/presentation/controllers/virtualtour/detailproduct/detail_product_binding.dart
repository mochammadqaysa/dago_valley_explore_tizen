import 'package:dago_valley_explore/presentation/controllers/virtualtour/detailproduct/detail_product_controller.dart';
import 'package:get/get.dart';

class DetailProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailProductController>(() => DetailProductController());
  }
}
