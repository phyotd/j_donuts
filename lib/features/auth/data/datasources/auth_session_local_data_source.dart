
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthSessionLocalDataSource {
  Future<void> saveUserId(String userId);

  Future<String?> getUserId();

  Future<void> clearSession();
}

class AuthSessionLocalDataSourceImpl
    implements AuthSessionLocalDataSource {
  final FlutterSecureStorage secureStorage;

  static const String _userIdKey = 'logged_in_user_id';

  const AuthSessionLocalDataSourceImpl({
    required this.secureStorage,
  });

  @override
  Future<void> saveUserId(String userId) {
    return secureStorage.write(
      key: _userIdKey,
      value: userId,
    );
  }

  @override
  Future<String?> getUserId() {
    return secureStorage.read(key: _userIdKey);
  }

  @override
  Future<void> clearSession() {
    return secureStorage.delete(key: _userIdKey);
  }
}
