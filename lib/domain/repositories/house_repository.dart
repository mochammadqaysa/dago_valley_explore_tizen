import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';

abstract class HouseRepository {
  Future<HousingResponse> fetchHousingData();
}
