import 'package:get/get.dart';
import 'mortgage_controller.dart';

class MortgageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MortgageController(Get.find()));
  }
}
