class City {
  final String cityId;
  final String cityName;
  final String provinceId;
  final String province;
  final String type;
  final String postalCode;

  City({
    required this.cityId,
    required this.cityName,
    required this.provinceId,
    required this.province,
    required this.type,
    required this.postalCode,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['city_id']?.toString() ?? '',
      cityName: json['city_name'] ?? '',
      provinceId: json['province_id']?.toString() ?? '',
      province: json['province'] ?? '',
      type: json['type'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'city_name': cityName,
      'province_id': provinceId,
      'province': province,
      'type': type,
      'postal_code': postalCode,
    };
  }

  String get displayName => '$type $cityName';
}

