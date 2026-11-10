import 'package:drift/drift.dart';
import 'package:j_donuts/core/database/app_database.dart' hide User;
import 'package:j_donuts/core/error/failures.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/data/datasources/auth_session_local_data_source.dart';
import 'package:j_donuts/features/auth/data/datasources/fake_auth_data_source.dart';
import 'package:j_donuts/features/auth/data/datasources/user_local_data_source.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FakeAuthDataSource _fakeAuthDataSource;
  final AuthSessionLocalDataSource _sessionDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(
    this._fakeAuthDataSource,
    this._sessionDataSource,
    this._userLocalDataSource,
  );

  @override
  Future<Result<void>> sendOtp({required String phoneNumber}) async {
    try {
      await _fakeAuthDataSource.sendOtp(phoneNumber: phoneNumber);
      return const Success<void>(null);
    } on AuthDataException catch (e) {
      return Error(ValidationFailure(e.message));
    } catch (_) {
      return Error(UnexpectedFailure('Unable to send OTP.'));
    }
  }

  @override
  Future<Result<User?>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final phone = phoneNumber.trim();

      await _fakeAuthDataSource.verifyOtp(phoneNumber: phone, otp: otp);
      final localUser = await _userLocalDataSource.getUserByPhone(phone);

      if (localUser == null) {
        return const Success<User?>(null);
      }
      await _sessionDataSource.saveUserId(localUser.id);
      return Success<User?>(
        User(
          id: localUser.id,
          phoneNumber: localUser.phoneNumber,
          firstName: localUser.firstName,
          lastName: localUser.lastName,
          dateOfBirth: localUser.dateOfBirth,
        ),
      );
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
      final phone = phoneNumber.trim();
      if (firstName.trim().isEmpty) {
        return Error(ValidationFailure('First name is required.'));
      }

      // Check whether this phone number is already registered.
      final existingUser = await _userLocalDataSource.getUserByPhone(phone);
      if (existingUser != null) {
        return Error(ValidationFailure('Phone number is already registered.'));
      }

      // Check registration OTP verification.
      final isVerified = _fakeAuthDataSource.consumeVerifiedPhone(
        phoneNumber: phone,
      );

      if (!isVerified) {
        return Error(
          AuthenticationFailure('Please verify your phone number first.'),
        );
      }

      final userId = 'user-${DateTime.now().microsecondsSinceEpoch}';

      await _userLocalDataSource.insertUser(
        UsersCompanion.insert(
          id: userId,
          phoneNumber: phone,
          firstName: firstName.trim(),
          lastName: Value(lastName?.trim()),
          dateOfBirth: dateOfBirth,
        ),
      );

      // Save login session into Secure Storage.
      await _sessionDataSource.saveUserId(userId);

      return Success(
        User(
          id: userId,
          phoneNumber: phone,
          firstName: firstName.trim(),
          lastName: lastName?.trim(),
          dateOfBirth: dateOfBirth,
        ),
      );
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
      final phone = phoneNumber.trim();

      // Find registered user from Drift.
      final localUser = await _userLocalDataSource.getUserByPhone(phone);

      if (localUser == null) {
        return Error(ValidationFailure('User not found.'));
      }

      await _fakeAuthDataSource.verifyOtp(phoneNumber: phone, otp: otp);

      await _sessionDataSource.saveUserId(localUser.id);

      return Success(
        User(
          id: localUser.id,
          phoneNumber: localUser.phoneNumber,
          firstName: localUser.firstName,
          lastName: localUser.lastName,
          dateOfBirth: localUser.dateOfBirth,
        ),
      );
    } on AuthDataException catch (e) {
      return Error(AuthenticationFailure(e.message));
    } catch (_) {
      return Error(UnexpectedFailure('Unable to login.'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _sessionDataSource.clearSession();
      return const Success<void>(null);
    } catch (_) {
      return Error(UnexpectedFailure('Unable to log out.'));
    }
  }
}
