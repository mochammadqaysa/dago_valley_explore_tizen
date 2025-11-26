import 'package:dago_valley_explore/domain/entities/brochure.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';

class Housing {
  int? id;
  String? name;
  String? alamat;
  String? logo;
  String? welcomeText;
  String? welcomeTextEn;
  String? createdAt;
  String? updatedAt;
  List<Promo>? promos;
  List<Event>? events;
  List<Brochure>? brochures;
  List<SitePlan>? siteplans;
  List<KprCalculator>? kprCalculators;

  Housing({
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
  });

  factory Housing.fromJson(Map<String, dynamic> json) => Housing(
    id: json['id'] as int?,
    name: json['name'] as String?,
    alamat: json['alamat'] as String?,
    logo: json['logo'] as String?,
    welcomeText: json['welcome_text'] as String?,
    welcomeTextEn: json['welcome_text_en'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    promos: (json['promos'] as List<dynamic>?)
        ?.map((e) => Promo.fromJson(e as Map<String, dynamic>))
        .toList(),
    events: (json['events'] as List<dynamic>?)
        ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
        .toList(),
    brochures: (json['brochures'] as List<dynamic>?)
        ?.map((e) => Brochure.fromJson(e as Map<String, dynamic>))
        .toList(),
    siteplans: (json['siteplans'] as List<dynamic>?)
        ?.map((e) => SitePlan.fromJson(e as Map<String, dynamic>))
        .toList(),
    kprCalculators: (json['kpr_calculators'] as List<dynamic>?)
        ?.map((e) => KprCalculator.fromJson(e as Map<String, dynamic>))
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
