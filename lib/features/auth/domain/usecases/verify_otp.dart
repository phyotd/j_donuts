import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<Result<void>> call({
    required String phoneNumber,
    required String otp,
  }) {
    return repository.verifyOtp(phoneNumber: phoneNumber, otp: otp);
  }
}
