import 'package:dago_valley_explore/domain/entities/site_plan.dart';

class SitePlanModel extends SitePlan {
  SitePlanModel({
    required this.id,
    required this.housingId,
    required this.name,
    required this.imageUrl,
    required this.mapUrl,
    required this.fasumUrl,
    required this.timelineProgressUrl,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         housingId: housingId,
         name: name,
         imageUrl: imageUrl,
         mapUrl: mapUrl,
         fasumUrl: fasumUrl,
         timelineProgressUrl: timelineProgressUrl,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  final int id;
  final String housingId;
  final String name;
  final String imageUrl;
  final String mapUrl;
  final String fasumUrl;
  final String timelineProgressUrl;
  final String createdAt;
  final String updatedAt;

  @override
  factory SitePlanModel.fromJson(Map<String, dynamic> json) => SitePlanModel(
    id: json["id"],
    housingId: json["housing_id"],
    name: json["name"],
    imageUrl: json["imageUrl"],
    mapUrl: json["mapUrl"],
    fasumUrl: json["fasumUrl"],
    timelineProgressUrl: json["timelineProgressUrl"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "housing_id": housingId,
    "name": name,
    "imageUrl": imageUrl,
    "mapUrl": mapUrl,
    "fasumUrl": fasumUrl,
    "timelineProgressUrl": timelineProgressUrl,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
