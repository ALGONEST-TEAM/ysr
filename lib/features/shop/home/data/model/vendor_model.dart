class VendorModel {
  final int id;
  final String name;
  final String? logo;
  final double? rating;
  final int? reviewsCount;
  final String? city;

  VendorModel({
    required this.id,
    required this.name,
    this.logo,
    this.rating,
    this.reviewsCount,
    this.city,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? json['logoUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'rating': rating,
      'reviews_count': reviewsCount,
      'city': city,
    };
  }

  VendorModel copyWith({
    int? id,
    String? name,
    String? logo,
    double? rating,
    int? reviewsCount,
    String? city,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      city: city ?? this.city,
    );
  }
}
