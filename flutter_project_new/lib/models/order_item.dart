class OrderItem {
  final String id;
  final String productName;
  final String materialName;
  final String sizeType; // Anak, Dewasa, Oversize
  final Map<String, int> sizes; // S: 2, M: 5, L: 8, etc.
  final String sleeveLength;
  final String collarType;
  final String baseColor;
  final int totalQuantity;
  final bool isPlayer; // true for pemain, false for kiper
  final String? designFile; // for uploaded design
  final String? templateName; // for template selection
  final double basePrice;
  final double materialPrice;
  final double sizeTypePrice;
  final double sleevePrice;
  final double collarPrice;
  final double designPrice;
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.productName,
    required this.materialName,
    required this.sizeType,
    required this.sizes,
    required this.sleeveLength,
    required this.collarType,
    required this.baseColor,
    required this.totalQuantity,
    required this.isPlayer,
    this.designFile,
    this.templateName,
    required this.basePrice,
    required this.materialPrice,
    required this.sizeTypePrice,
    required this.sleevePrice,
    required this.collarPrice,
    required this.designPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'materialName': materialName,
      'sizeType': sizeType,
      'sizes': sizes,
      'sleeveLength': sleeveLength,
      'collarType': collarType,
      'baseColor': baseColor,
      'totalQuantity': totalQuantity,
      'isPlayer': isPlayer,
      'designFile': designFile,
      'templateName': templateName,
      'basePrice': basePrice,
      'materialPrice': materialPrice,
      'sizeTypePrice': sizeTypePrice,
      'sleevePrice': sleevePrice,
      'collarPrice': collarPrice,
      'designPrice': designPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productName: json['productName'],
      materialName: json['materialName'],
      sizeType: json['sizeType'],
      sizes: Map<String, int>.from(json['sizes']),
      sleeveLength: json['sleeveLength'],
      collarType: json['collarType'],
      baseColor: json['baseColor'],
      totalQuantity: json['totalQuantity'],
      isPlayer: json['isPlayer'],
      designFile: json['designFile'],
      templateName: json['templateName'],
      basePrice: json['basePrice'].toDouble(),
      materialPrice: json['materialPrice'].toDouble(),
      sizeTypePrice: json['sizeTypePrice'].toDouble(),
      sleevePrice: json['sleevePrice'].toDouble(),
      collarPrice: json['collarPrice'].toDouble(),
      designPrice: json['designPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}

