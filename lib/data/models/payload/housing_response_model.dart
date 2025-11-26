import 'package:dago_valley_explore/data/models/housing_model.dart';
import 'package:dago_valley_explore/data/models/version_model.dart';
import 'package:dago_valley_explore/domain/entities/payload/housing_response.dart';

class HousingResponseModel extends HousingResponse {
  HousingResponseModel({required this.housing, required this.version})
    : super(housing: housing, version: version);

  final List<HousingModel> housing;
  final VersionModel version;

  @override
  factory HousingResponseModel.fromJson(Map<String, dynamic> json) =>
      HousingResponseModel(
        housing: List.from(
          json["housing"].map((x) => HousingModel.fromJson(x)),
        ),
        version: VersionModel.fromJson(json["versions"]),
      );
}
