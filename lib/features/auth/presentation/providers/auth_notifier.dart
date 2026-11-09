import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';
import 'package:j_donuts/features/auth/presentation/providers/auth_providers.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return null;
  }

  Future<Result<void>> sendOtp({required String phoneNumber}) async {
    return ref.read(sendOtpProvider)(phoneNumber: phoneNumber);
  }

  Future<Result<void>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    return ref.read(verifyOtpProvider)(phoneNumber: phoneNumber, otp: otp);
  }

  Future<Result<User>> register({
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String firstName,
    String? lastName,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(completeRegistrationProvider)(
      dateOfBirth: dateOfBirth,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );

    if (result is Success<User>) {
      state = AsyncData(result.data);
    } else {
      state = const AsyncData(null);
    }

    return result;
  }

  Future<Result<User>> login({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(loginWithOtpProvider)(
      phoneNumber: phoneNumber,
      otp: otp,
    );

    if (result is Success<User>) {
      state = AsyncData(result.data);
    } else {
      state = const AsyncData(null);
    }

    return result;
  }

  Future<Result<void>> logout() async {
    final result = await ref.read(logoutUserProvider)();

    if (result is Success<void>) {
      state = const AsyncData(null);
    }

    return result;
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
