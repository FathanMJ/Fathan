class MaterialModel {
  final int? id;
  final String name;
  final String description;
  final String priceIncrease;
  final int priceIncreaseValue; // To be used for calculation later
  final String? imageUrl;

  const MaterialModel({
    this.id,
    required this.name,
    required this.description,
    required this.priceIncrease,
    this.priceIncreaseValue = 0,
    this.imageUrl,
  });
}
