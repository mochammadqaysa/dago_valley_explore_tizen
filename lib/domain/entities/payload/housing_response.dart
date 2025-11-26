import 'package:dago_valley_explore/domain/entities/housing.dart';
import 'package:dago_valley_explore/domain/entities/version.dart';

class HousingResponse {
  final List<Housing> housing;
  final Version version;

  HousingResponse({required this.housing, required this.version});
}
