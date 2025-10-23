class MaterialModel {
  final String name;
  final String description;
  final String priceIncrease;
  final int priceIncreaseValue; // To be used for calculation later

  const MaterialModel({
    required this.name,
    required this.description,
    required this.priceIncrease,
    this.priceIncreaseValue = 0,
  });
}
