class Subdistrict {
  final String subdistrictId;
  final String subdistrictName;
  final String cityId;
  final String cityName;
  final String provinceId;
  final String provinceName;

  Subdistrict({
    required this.subdistrictId,
    required this.subdistrictName,
    required this.cityId,
    required this.cityName,
    required this.provinceId,
    required this.provinceName,
  });

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      subdistrictId: json['subdistrict_id']?.toString() ?? json['id']?.toString() ?? '',
      subdistrictName: json['subdistrict_name'] ?? json['name'] ?? '',
      cityId: json['city_id']?.toString() ?? '',
      cityName: json['city_name'] ?? json['city'] ?? '',
      provinceId: json['province_id']?.toString() ?? '',
      provinceName: json['province_name'] ?? json['province'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subdistrict_id': subdistrictId,
      'subdistrict_name': subdistrictName,
      'city_id': cityId,
      'city_name': cityName,
      'province_id': provinceId,
      'province_name': provinceName,
    };
  }
}

