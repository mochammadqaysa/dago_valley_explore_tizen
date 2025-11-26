import 'package:dago_valley_explore/data/models/brochure_model.dart';
import 'package:dago_valley_explore/data/models/event_model.dart';
import 'package:dago_valley_explore/data/models/kpr_calculator_model.dart';
import 'package:dago_valley_explore/data/models/promo_model.dart';
import 'package:dago_valley_explore/data/models/site_plan_model.dart';
import 'package:dago_valley_explore/domain/entities/housing.dart';

class HousingModel extends Housing {
  HousingModel({
    this.id,
    this.name,
    this.alamat,
    this.logo,
    this.welcomeText,
    this.welcomeTextEn,
    this.createdAt,
    this.updatedAt,
    this.promos,
    this.events,
    this.brochures,
    this.siteplans,
    this.kprCalculators,
  }) : super(
         id: id,
         name: name,
         alamat: alamat,
         logo: logo,
         welcomeText: welcomeText,
         welcomeTextEn: welcomeTextEn,
         createdAt: createdAt,
         updatedAt: updatedAt,
         promos: promos,
         events: events,
         brochures: brochures,
         siteplans: siteplans,
         kprCalculators: kprCalculators,
       );

  final int? id;
  final String? name;
  final String? alamat;
  final String? logo;
  final String? welcomeText;
  final String? welcomeTextEn;
  final String? createdAt;
  final String? updatedAt;
  final List<PromoModel>? promos;
  final List<EventModel>? events;
  final List<BrochureModel>? brochures;
  final List<SitePlanModel>? siteplans;
  final List<KprCalculatorModel>? kprCalculators;

  factory HousingModel.fromJson(Map<String, dynamic> json) => HousingModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    alamat: json['alamat'] as String?,
    logo: json['logo'] as String?,
    welcomeText: json['welcome_text'] as String?,
    welcomeTextEn: json['welcome_text_en'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    promos: (json['promos'] as List<dynamic>?)
        ?.map((e) => PromoModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    events: (json['events'] as List<dynamic>?)
        ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    brochures: (json['brochures'] as List<dynamic>?)
        ?.map((e) => BrochureModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    siteplans: (json['siteplans'] as List<dynamic>?)
        ?.map((e) => SitePlanModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    kprCalculators: (json['kpr_calculators'] as List<dynamic>?)
        ?.map((e) => KprCalculatorModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'alamat': alamat,
    'logo': logo,
    'welcome_text': welcomeText,
    'welcome_text_en': welcomeTextEn,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'promos': promos?.map((e) => e.toJson()).toList(),
    'events': events?.map((e) => e.toJson()).toList(),
    'brochures': brochures?.map((e) => e.toJson()).toList(),
    'siteplans': siteplans?.map((e) => e.toJson()).toList(),
    'kpr_calculators': kprCalculators?.map((e) => e.toJson()).toList(),
  };
}
