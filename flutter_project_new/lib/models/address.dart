class Address {
  final String street;
  final String city;
  final String province;
  final String postalCode;
  final bool isPrimary;

  Address({
    required this.street,
    required this.city,
    required this.province,
    required this.postalCode,
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'isPrimary': isPrimary,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postalCode'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}
