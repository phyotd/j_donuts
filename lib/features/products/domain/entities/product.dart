class Product {
  final String id;
  final String code;
  final double price;
  final bool isNew;
  final double? discountPercent;
  final String description;
  final String name;
  final String imageUrl;

  const Product({
    required this.id,
    required this.code,
    required this.price,
    required this.isNew,
    this.discountPercent,
    required this.description,
    required this.name,
    required this.imageUrl,
  });
}