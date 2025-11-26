import 'package:dago_valley_explore/presentation/controllers/promo/promo_controller.dart';
import 'package:dago_valley_explore/presentation/controllers/qrcode/qrcode_controller.dart';
import 'package:get/get.dart';

class QrCodeBinding extends Bindings {
  final String? initialUrl;

  QrCodeBinding({this.initialUrl});
  @override
  void dependencies() {
    final argUrl = Get.arguments as String?;
    final url = argUrl ?? initialUrl;
    Get.lazyPut<QRCodeController>(() => QRCodeController(url));
  }
}
