import 'package:j_donuts/features/products/data/datasources/product_mock_data.dart';
import 'package:j_donuts/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return ProductMockData.products;
  }
}
