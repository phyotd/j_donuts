import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<void>> sendOtp({required String phoneNumber});

  Future<Result<void>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<Result<User>> completeRegistration({
    required String phoneNumber,
    required String firstName,
    String? lastName,
    required DateTime dateOfBirth,
  });

  Future<Result<User>> verifyOtpAndLogin({
    required String phoneNumber,
    required String otp,
  });

  Future<Result<void>> logout();
}
