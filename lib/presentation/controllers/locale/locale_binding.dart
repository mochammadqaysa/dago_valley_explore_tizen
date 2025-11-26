import 'package:get/get.dart';
import 'locale_controller.dart';

class LocaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocaleController>(() => LocaleController());
  }
}
