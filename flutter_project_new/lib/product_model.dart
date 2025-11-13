class Product {
  final int? id;
  final String name;
  final String image;
  final String description;
  final String minPrice;

  const Product({
    this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.minPrice,
  });

  // Optional: Factory constructor to create a Product from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? map['id_produk'],
      name: map['name'] ?? map['nama'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? map['deskripsi'] ?? '',
      minPrice: map['minPrice'] ?? '',
    );
  }
}
