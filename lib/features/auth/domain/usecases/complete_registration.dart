import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class CompleteRegistration {
  final AuthRepository _repository;

  CompleteRegistration(this._repository);

  Future<Result<User>> call({
    required String phoneNumber,
    required String firstName,
    String? lastName,
    required DateTime dateOfBirth,
  }) {
    return _repository.completeRegistration(
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
    );
  }
}
