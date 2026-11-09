import 'package:j_donuts/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}