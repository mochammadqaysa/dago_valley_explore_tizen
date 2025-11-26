import 'package:dago_valley_explore/data/models/payload/housing_response_model.dart';
import 'package:dago_valley_explore/data/providers/network/apis/housing_api.dart';
import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';
import 'package:dago_valley_explore/domain/repositories/house_repository.dart';

class HouseRepositoryImpl extends HouseRepository {
  @override
  Future<HousingResponse> fetchHousingData() async {
    final response = await HousingApi.fetchHousingData().request();
    return HousingResponseModel.fromJson(response);
  }
}
