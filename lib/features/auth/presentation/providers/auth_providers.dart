import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:j_donuts/core/database/app_database.dart';
import 'package:j_donuts/core/database/database_provider.dart';
import 'package:j_donuts/features/auth/data/datasources/auth_session_local_data_source.dart';
import 'package:j_donuts/features/auth/data/datasources/fake_auth_data_source.dart';
import 'package:j_donuts/features/auth/data/datasources/user_local_data_source.dart';
import 'package:j_donuts/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';
import 'package:j_donuts/features/auth/domain/usecases/complete_registration.dart';
import 'package:j_donuts/features/auth/domain/usecases/login_with_otp.dart';
import 'package:j_donuts/features/auth/domain/usecases/logout_user.dart';
import 'package:j_donuts/features/auth/domain/usecases/verify_otp.dart';
import 'package:j_donuts/features/auth/domain/usecases/sent_otp.dart';

final appDatabaseProvider = databaseProvider;

final userLocalDataSourceProvider = Provider<UserLocalDataSource>(
  (ref) => UserLocalDataSourceImpl(database: ref.watch(appDatabaseProvider)),
);

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final authSessionLocalDataSourceProvider = Provider<AuthSessionLocalDataSource>(
  (ref) => AuthSessionLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

final fakeAuthDataSourceProvider = Provider<FakeAuthDataSource>(
  (ref) => FakeAuthDataSource(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(fakeAuthDataSourceProvider),
    ref.watch(authSessionLocalDataSourceProvider),
    ref.watch(userLocalDataSourceProvider),
  );
});

final sendOtpProvider = Provider<SendOtp>((ref) {
  return SendOtp(ref.watch(authRepositoryProvider));
});

final loginWithOtpProvider = Provider<LoginWithOtp>((ref) {
  return LoginWithOtp(ref.watch(authRepositoryProvider));
});

final verifyOtpProvider = Provider<VerifyOtp>((ref) {
  return VerifyOtp(ref.watch(authRepositoryProvider));
});

final completeRegistrationProvider = Provider<CompleteRegistration>((ref) {
  return CompleteRegistration(ref.watch(authRepositoryProvider));
});

final logoutUserProvider = Provider<LogoutUser>((ref) {
  return LogoutUser(ref.watch(authRepositoryProvider));
});
