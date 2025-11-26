import 'package:dago_valley_explore/domain/entities/promo_translation.dart';

class PromoTranslationModel extends PromoTranslation {
  PromoTranslationModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tag1,
    required this.tag2,
  }) : super(
         title: title,
         subtitle: subtitle,
         description: description,
         tag1: tag1,
         tag2: tag2,
       );

  final String title;
  final String subtitle;
  final String description;
  final String tag1;
  final String tag2;

  @override
  factory PromoTranslationModel.fromJson(Map<String, dynamic> json) =>
      PromoTranslationModel(
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        tag1: json["tag1"],
        tag2: json["tag2"],
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'tag1': tag1,
    'tag2': tag2,
  };
}
