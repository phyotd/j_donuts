import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  const LogoutUser(this.repository);

  Future<Result<void>> call() {
    return repository.logout();
  }
}
