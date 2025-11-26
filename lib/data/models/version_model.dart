import 'package:dago_valley_explore/domain/entities/version.dart';

class VersionModel extends Version {
  VersionModel({
    required this.promoVersion,
    required this.eventVersion,
    required this.productVersion,
    required this.brochureVersion,
    required this.siteplanVersion,
    required this.kprCalculatorVersion,
  }) : super(
         promoVersion: promoVersion,
         eventVersion: eventVersion,
         productVersion: productVersion,
         brochureVersion: brochureVersion,
         siteplanVersion: siteplanVersion,
         kprCalculatorVersion: kprCalculatorVersion,
       );

  final String promoVersion;
  final String eventVersion;
  final String productVersion;
  final String brochureVersion;
  final String siteplanVersion;
  final String kprCalculatorVersion;

  @override
  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
    promoVersion: json["promo_version"],
    eventVersion: json["event_version"],
    productVersion: json["product_version"],
    brochureVersion: json["brochure_version"],
    siteplanVersion: json["siteplan_version"],
    kprCalculatorVersion: json["kpr_calculator_version"],
  );
}
