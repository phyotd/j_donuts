import 'package:j_donuts/core/database/app_database.dart';
import 'package:j_donuts/features/products/data/datasources/product_mock_data.dart';
import 'package:j_donuts/features/products/data/mappers/product_mapper.dart';

class ProductSeeder {
  ProductSeeder(this.database);

  final AppDatabase database;

  Future<void> seed() async {
    final mockProducts = ProductMockData.products;
    // Insert missing products
    final products = mockProducts
        .map((product) => product.toCompanion())
        .toList();

    await database.insertProducts(products);

    for (final product in mockProducts) {
      await database.updateProductPopularity(product.id, product.isPopular);
    }
  }
}
