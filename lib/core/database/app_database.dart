import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/users.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CREATE
  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  // READ
  Future<User?> getUserByPhone(String phoneNumber) {
    return (select(
      users,
    )..where((tbl) => tbl.phoneNumber.equals(phoneNumber))).getSingleOrNull();
  }

  // UPDATE
  Future<bool> updateUser(UsersCompanion user) {
    return update(users).replace(user);
  }

  // DELETE
  Future<int> deleteUser(String id) {
    return (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'j_donuts_db');
}
