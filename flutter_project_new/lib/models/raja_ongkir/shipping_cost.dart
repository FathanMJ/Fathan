class ShippingCost {
  final String code;
  final String name;
  final List<Cost> costs;

  ShippingCost({
    required this.code,
    required this.name,
    required this.costs,
  });

  factory ShippingCost.fromJson(Map<String, dynamic> json) {
    return ShippingCost(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      costs: (json['costs'] as List<dynamic>?)
              ?.map((cost) => Cost.fromJson(cost as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Cost {
  final String service;
  final String description;
  final List<CostDetail> costDetails;

  Cost({
    required this.service,
    required this.description,
    required this.costDetails,
  });

  factory Cost.fromJson(Map<String, dynamic> json) {
    return Cost(
      service: json['service'] ?? '',
      description: json['description'] ?? '',
      costDetails: (json['cost'] as List<dynamic>?)
              ?.map((detail) => CostDetail.fromJson(detail as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  int get totalCost => costDetails.isNotEmpty ? costDetails.first.value : 0;
  String get etd => costDetails.isNotEmpty ? costDetails.first.etd : '';
}

class CostDetail {
  final int value;
  final String etd;
  final String note;

  CostDetail({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory CostDetail.fromJson(Map<String, dynamic> json) {
    return CostDetail(
      value: json['value'] ?? 0,
      etd: json['etd'] ?? '',
      note: json['note'] ?? '',
    );
  }
}

