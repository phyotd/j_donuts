import 'package:j_donuts/features/products/domain/entities/product.dart';
import 'package:j_donuts/features/products/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  const GetProducts(this.repository);

  Future<List<Product>> call() {
    return repository.getProducts();
  }
}