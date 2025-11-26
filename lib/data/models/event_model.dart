import 'package:dago_valley_explore/data/models/event_media_model.dart';
import 'package:dago_valley_explore/data/models/promo_translation_model.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    required this.id,
    required this.housingId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tag1,
    required this.tag2,
    required this.en,
    required this.images,
    required this.videos,
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
         images: images,
         videos: videos,
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
  final List<EventMediaModel> images;
  final List<EventMediaModel> videos;

  @override
  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json["id"],
    housingId: json["housing_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    tag1: json["tag1"],
    tag2: json["tag2"],
    en: PromoTranslationModel.fromJson(json["en"]),
    images: List<EventMediaModel>.from(
      json["images"].map((x) => EventMediaModel.fromJson(x)),
    ),
    videos: List<EventMediaModel>.from(
      json["videos"].map((x) => EventMediaModel.fromJson(x)),
    ),
  );
}
