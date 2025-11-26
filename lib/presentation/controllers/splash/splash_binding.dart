import 'package:dago_valley_explore/data/repositories/house_repository.dart';
import 'package:dago_valley_explore/domain/repositories/house_repository.dart';
import 'package:dago_valley_explore/domain/usecases/fetch_housing_use_case.dart';
import 'package:dago_valley_explore/presentation/controllers/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print('📦 Initializing SplashBinding dependencies...');

    // ✅ Gunakan fenix: true untuk auto-recreate jika sudah dihapus
    // Repository
    Get.lazyPut<HouseRepository>(() => HouseRepositoryImpl(), fenix: true);

    // UseCase
    Get.lazyPut(
      () => FetchHousingDataUseCase(Get.find<HouseRepository>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut(
      () => SplashController(Get.find<FetchHousingDataUseCase>()),
      fenix: true,
    );

    print('✅ SplashBinding dependencies initialized');
  }
}
