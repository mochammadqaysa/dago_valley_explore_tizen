import 'package:dago_valley_explore/domain/entities/brochure.dart';

class BrochureModel extends Brochure {
  BrochureModel({
    required this.id,
    required this.housingId,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         housingId: housingId,
         imageUrl: imageUrl,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  final int id;
  final String housingId;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  @override
  factory BrochureModel.fromJson(Map<String, dynamic> json) => BrochureModel(
    id: json["id"],
    housingId: json["housing_id"],
    imageUrl: json["imageUrl"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );
}
