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

  static const mockVendors = [
    {
      'id': 1,
      'name': 'متجر الأناقة الرياضية',
      'rating': 4.8,
      'reviews_count': 95,
      'logo': 'https://img.freepik.com/free-vector/bird-colorful-logo-gradient-vector_343694-1365.jpg',
      'city': 'صنعاء - الزبيري'
    },
    {
      'id': 2,
      'name': 'مؤسسة التقنية الحديثة',
      'rating': 4.9,
      'reviews_count': 140,
      'logo': 'https://img.freepik.com/free-vector/gradient-bird-logo-template_23-2151128362.jpg',
      'city': 'صنعاء - حدة'
    },
    {
      'id': 3,
      'name': 'متجر يسر الرسمي',
      'rating': 5.0,
      'reviews_count': 320,
      'logo': 'https://img.freepik.com/free-vector/modern-eagle-logo-design_1332-1599.jpg',
      'city': 'صنعاء - الأصبحي'
    },
  ];
}
