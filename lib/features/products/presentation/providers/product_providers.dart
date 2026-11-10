import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:j_donuts/core/database/database_provider.dart';
import 'package:j_donuts/features/products/data/datasources/product_local_data_source.dart';
import 'package:j_donuts/features/products/data/repositories/product_repository_impl.dart';
import 'package:j_donuts/features/products/domain/repositories/product_repository.dart';
import 'package:j_donuts/features/products/domain/usecases/get_products.dart';

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return ProductLocalDataSourceImpl(database);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    localDataSource: ref.read(productLocalDataSourceProvider),
  );
});

final getProductsProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.read(productRepositoryProvider));
});

final productsProvider = FutureProvider((ref) async {
  final getProducts = ref.read(getProductsProvider);
  return getProducts();
});

final seasonalProductsProvider = Provider((ref) {
  final productsAsync = ref.watch(productsProvider);

  return productsAsync.when(
    data: (products) => products.where((p) => p.isNew).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

final popularProductsProvider = Provider((ref) {
  final productsAsync = ref.watch(productsProvider);

  return productsAsync.when(
    data: (products) => products.where((p) => p.isPopular).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});
