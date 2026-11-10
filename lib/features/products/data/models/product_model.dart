import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.code,
    required super.price,
    required super.isNew,
    super.isPopular = false,
    super.discountPercent,
    required super.description,
    required super.name,
    required super.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      code: json['code'] as String,
      price: (json['price'] as num).toDouble(),
      isNew: json['isNew'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      description: json['description'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'price': price,
      'isNew': isNew,
      'isPopular': isPopular,
      'discountPercent': discountPercent,
      'description': description,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
