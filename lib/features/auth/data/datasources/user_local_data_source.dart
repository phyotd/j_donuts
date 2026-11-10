import 'package:j_donuts/core/database/app_database.dart';

abstract class UserLocalDataSource {
  Future<int> insertUser(UsersCompanion user);

  Future<User?> getUserByPhone(String phoneNumber);

  Future<bool> updateUser(UsersCompanion user);

  Future<int> deleteUser(String id);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final AppDatabase database;

  const UserLocalDataSourceImpl({required this.database});

  @override
  Future<int> insertUser(UsersCompanion user) {
    return database.insertUser(user);
  }

  @override
  Future<User?> getUserByPhone(String phoneNumber) {
    return database.getUserByPhone(phoneNumber);
  }

  @override
  Future<bool> updateUser(UsersCompanion user) {
    return database.updateUser(user);
  }

  @override
  Future<int> deleteUser(String id) {
    return database.deleteUser(id);
  }
}
