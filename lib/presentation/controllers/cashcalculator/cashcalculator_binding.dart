import 'package:get/get.dart';
import '../../../app/services/local_storage.dart';
import 'cashcalculator_controller.dart';

class CashcalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CashcalculatorController());
  }
}
