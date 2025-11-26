class Version {
  final String promoVersion;
  final String eventVersion;
  final String productVersion;
  final String brochureVersion;
  final String siteplanVersion;
  final String kprCalculatorVersion;

  Version({
    required this.promoVersion,
    required this.eventVersion,
    required this.productVersion,
    required this.brochureVersion,
    required this.siteplanVersion,
    required this.kprCalculatorVersion,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    promoVersion: json['promo_version'],
    eventVersion: json['event_version'],
    productVersion: json['product_version'],
    brochureVersion: json['brochure_version'],
    siteplanVersion: json['siteplan_version'],
    kprCalculatorVersion: json['kpr_calculator_version'],
  );

  Map<String, dynamic> toJson() => {
    'promo_version': promoVersion,
    'event_version': eventVersion,
    'product_version': productVersion,
    'brochure_version': brochureVersion,
    'siteplan_version': siteplanVersion,
    'kpr_calculator_version': kprCalculatorVersion,
  };
}
