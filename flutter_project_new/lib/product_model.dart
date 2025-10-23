class Product {
  final String name;
  final String image;
  final String description;
  final String minPrice;

  const Product({
    required this.name,
    required this.image,
    required this.description,
    required this.minPrice,
  });

  // Optional: Factory constructor to create a Product from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      minPrice: map['minPrice'] ?? '',
    );
  }
}
