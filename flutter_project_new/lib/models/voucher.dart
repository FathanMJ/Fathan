class Voucher {
  final String code;
  final String description;
  final bool isUsed;
  final DateTime? expiryDate;

  Voucher({
    required this.code,
    required this.description,
    this.isUsed = false,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'isUsed': isUsed,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      code: json['code'],
      description: json['description'],
      isUsed: json['isUsed'] ?? false,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) 
          : null,
    );
  }
}
