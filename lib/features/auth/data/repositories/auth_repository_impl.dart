import 'package:j_donuts/core/error/failures.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/data/datasources/fake_auth_data_source.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FakeAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Result<void>> sendOtp({required String phoneNumber}) async {
    try {
      await _dataSource.sendOtp(phoneNumber: phoneNumber);
      return const Success<void>(null);
    } on AuthDataException catch (e) {
      return Error(ValidationFailure(e.message));
    } catch (_) {
      return Error(UnexpectedFailure('Unable to send OTP.'));
    }
  }

  @override
  Future<Result<void>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      await _dataSource.verifyOtp(phoneNumber: phoneNumber, otp: otp);
      return const Success<void>(null);
    } on AuthDataException catch (e) {
      return Error(AuthenticationFailure(e.message));
    } catch (_) {
      return Error(UnexpectedFailure('Unable to verify OTP.'));
    }
  }

  @override
  Future<Result<User>> completeRegistration({
    required String phoneNumber,
    required String firstName,
    String? lastName,
    required DateTime dateOfBirth,
  }) async {
    try {
      final user = await _dataSource.completeRegistration(
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );

      return Success(user.toEntity());
    } on AuthDataException catch (e) {
      return Error(ValidationFailure(e.message));
    } catch (_) {
      return Error(UnexpectedFailure('Unable to complete registration.'));
    }
  }

  @override
  Future<Result<User>> verifyOtpAndLogin({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final user = await _dataSource.verifyOtpAndLogin(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      return Success(user.toEntity());
    } on AuthDataException catch (e) {
      return Error(AuthenticationFailure(e.message));
    } catch (_) {
      return Error(UnexpectedFailure('Unable to login.'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dataSource.logout();
      return const Success<void>(null);
    } catch (_) {
      return Error(UnexpectedFailure('Unable to log out.'));
    }
  }
}
