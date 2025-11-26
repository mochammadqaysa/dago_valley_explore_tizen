class Brochure {
  final int id;
  final String housingId;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  Brochure({
    required this.id,
    required this.housingId,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brochure.fromJson(Map<String, dynamic> json) => Brochure(
    id: json["id"],
    housingId: json["housing_id"],
    imageUrl: json["imageUrl"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "housing_id": housingId,
    "imageUrl": imageUrl,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
