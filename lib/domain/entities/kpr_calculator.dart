class KprCalculator {
  final int id;
  final String housingId;
  final String marginDeveloper;
  final String marginBankSyariah;
  final String dpDeveloper;
  final String dpSyariah;
  final String createdAt;
  final String updatedAt;

  KprCalculator({
    required this.id,
    required this.housingId,
    required this.marginDeveloper,
    required this.marginBankSyariah,
    required this.dpDeveloper,
    required this.dpSyariah,
    required this.createdAt,
    required this.updatedAt,
  });

  // Methods to convert string values to numeric values for calculations
  double get dpDeveloperValue {
    try {
      // Convert percentage string to decimal (e.g. "30%" -> 0.3)
      if (dpDeveloper.contains('%')) {
        return double.parse(dpDeveloper.replaceAll('%', '')) / 100;
      } else {
        // If it's already a decimal value as string (e.g. "0.3")
        return double.parse(dpDeveloper) / 100;
      }
    } catch (e) {
      // Default to 0.3 if parsing fails
      return 0.3;
    }
  }

  double get dpSyariahValue {
    try {
      // Convert percentage string to decimal (e.g. "20%" -> 0.2)
      if (dpSyariah.contains('%')) {
        return double.parse(dpSyariah.replaceAll('%', '')) / 100;
      } else {
        // If it's already a decimal value as string (e.g. "0.2")
        return double.parse(dpSyariah) / 100;
      }
    } catch (e) {
      // Default to 0.2 if parsing fails
      return 0.2;
    }
  }

  double get marginDeveloperValue {
    try {
      // Convert percentage string to decimal (e.g. "5.25%" -> 0.0525)
      if (marginDeveloper.contains('%')) {
        return double.parse(marginDeveloper.replaceAll('%', '')) / 100;
      } else {
        // If it's already a decimal value as string (e.g. "0.0525")
        return double.parse(marginDeveloper);
      }
    } catch (e) {
      // Default to 0.0525 if parsing fails
      return 0.0525;
    }
  }

  double get marginBankSyariahValue {
    try {
      // Convert percentage string to decimal (e.g. "11%" -> 0.11)
      if (marginBankSyariah.contains('%')) {
        return double.parse(marginBankSyariah.replaceAll('%', '')) / 100;
      } else {
        // If it's already a decimal value as string (e.g. "0.11")
        return double.parse(marginBankSyariah);
      }
    } catch (e) {
      // Default to 0.11 if parsing fails
      return 0.11;
    }
  }

  factory KprCalculator.fromJson(Map<String, dynamic> json) => KprCalculator(
    id: json["id"],
    housingId: json["housing_id"],
    marginDeveloper: json["margin_developer"],
    marginBankSyariah: json["margin_syariah"],
    dpDeveloper: json["dp_developer"],
    dpSyariah: json["dp_syariah"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "housing_id": housingId,
    "margin_developer": marginDeveloper,
    "margin_syariah": marginBankSyariah,
    "dp_developer": dpDeveloper,
    "dp_syariah": dpSyariah,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
