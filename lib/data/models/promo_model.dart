import 'package:dago_valley_explore/data/models/promo_translation_model.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';

class PromoModel extends Promo {
  PromoModel({
    required this.id,
    required this.housingId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
    required this.en,
  }) : super(
         id: id,
         housingId: housingId,
         title: title,
         subtitle: subtitle,
         description: description,
         imageUrl: imageUrl,
         tag1: tag1,
         tag2: tag2,
         en: en,
       );

  final int id;
  final String housingId;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String tag1;
  final String tag2;
  final PromoTranslationModel en;

  @override
  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
    id: json["id"],
    housingId: json["housing_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    tag1: json["tag1"],
    tag2: json["tag2"],
    en: PromoTranslationModel.fromJson(json["en"]),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'housing_id': housingId,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'imageUrl': imageUrl,
    'tag1': tag1,
    'tag2': tag2,
    'en': en?.toJson(),
  };
}
