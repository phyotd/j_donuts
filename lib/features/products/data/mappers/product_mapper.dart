import 'package:drift/drift.dart';
import 'package:j_donuts/core/database/app_database.dart';
import 'package:j_donuts/features/products/data/models/product_model.dart';

extension ProductMapper on ProductModel {
  ProductsCompanion toCompanion() {
    return ProductsCompanion.insert(
      id: id,
      code: code,
      price: price,
      isNew: isNew,
      isPopular: Value(isPopular),
      discountPercent: Value(discountPercent),
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }
}