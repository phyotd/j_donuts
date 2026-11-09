import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class LoginWithOtp {
  final AuthRepository repository;

  LoginWithOtp(this.repository);

  Future<Result<User>> call({
    required String phoneNumber,
    required String otp,
  }) {
    return repository.verifyOtpAndLogin(phoneNumber: phoneNumber, otp: otp);
  }
}
