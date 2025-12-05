class Address {
  final int? id;
  final String street;
  final String city;
  final String province;
  final String postalCode;
  final String? telepon;
  final bool isPrimary;

  Address({
    this.id,
    required this.street,
    required this.city,
    required this.province,
    required this.postalCode,
    this.telepon,
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'telepon': telepon,
      'isPrimary': isPrimary,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postalCode'],
      telepon: json['telepon'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  /// From API JSON (Laravel format)
  factory Address.fromApiJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['alamat_lengkap'] ?? '',
      city: json['kota'] ?? '',
      province: json['provinsi'] ?? '',
      postalCode: json['kode_pos'] ?? '',
      telepon: json['telepon'],
      isPrimary: json['is_primary'] ?? false,
    );
  }

  /// To API JSON (Laravel format)
  Map<String, dynamic> toApiJson() {
    return {
      'alamat_lengkap': street,
      'kota': city,
      'provinsi': province,
      'kode_pos': postalCode,
      'telepon': telepon,
      'is_primary': isPrimary,
    };
  }

  String get fullAddress {
    return '$street, $city, $province $postalCode';
  }
}
