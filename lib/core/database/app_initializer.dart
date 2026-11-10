import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:j_donuts/core/database/database_provider.dart';
import 'package:j_donuts/core/database/seeders/product_seeder.dart';

final appInitializerProvider = FutureProvider<void>((ref) async {
  final database = ref.watch(databaseProvider);

  final productSeeder = ProductSeeder(database);

  await productSeeder.seed();
});