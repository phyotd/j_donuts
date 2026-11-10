import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/users.dart';
import 'tables/products.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // Check whether products table exists.
      final tableResult = await customSelect(
        "SELECT name FROM sqlite_master "
        "WHERE type = 'table' AND name = 'products'",
      ).get();

      if (tableResult.isEmpty) {
        await migrator.createTable(products);
      }

      // Check whether isPopular column exists.
      final columnResult = await customSelect(
        'PRAGMA table_info(products)',
      ).get();

      final hasIsPopular = columnResult.any(
        (row) => row.read<String>('name') == 'is_popular',
      );

      if (!hasIsPopular) {
        await migrator.addColumn(products, products.isPopular);
      }
    },
  );

  // Users
  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<User?> getUserByPhone(String phoneNumber) {
    return (select(
      users,
    )..where((tbl) => tbl.phoneNumber.equals(phoneNumber))).getSingleOrNull();
  }

  Future<bool> updateUser(UsersCompanion user) {
    return update(users).replace(user);
  }

  Future<int> deleteUser(String id) {
    return (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Products
  Future<List<Product>> getAllProducts() {
    return select(products).get();
  }

  Future<int> insertProduct(ProductsCompanion product) {
    return into(products).insert(product, mode: InsertMode.insertOrIgnore);
  }

  Future<void> insertProducts(List<ProductsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(products, items, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> updateProductPopularity(String productId, bool isPopular) async {
    await (update(products)..where((tbl) => tbl.id.equals(productId))).write(
      ProductsCompanion(isPopular: Value(isPopular)),
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'j_donuts_db');
}
