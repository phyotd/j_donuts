import 'package:j_donuts/features/products/data/datasources/product_local_data_source.dart';

import 'package:j_donuts/features/products/domain/entities/product.dart';
import 'package:j_donuts/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Product>> getProducts() async {
    return await localDataSource.getProducts();
  }
}
