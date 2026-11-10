
import 'package:j_donuts/core/database/app_database.dart';
import 'package:j_donuts/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this.database);

  final AppDatabase database;

  @override
  Future<List<ProductModel>> getProducts() async {
    final products = await database.getAllProducts();

    return products.map((product) {
      return ProductModel(
        id: product.id,
        code: product.code,
        price: product.price,
        isNew: product.isNew,
        isPopular: product.isPopular,
        discountPercent: product.discountPercent,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
      );
    }).toList();
  }
}
