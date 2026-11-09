import 'package:j_donuts/features/auth/data/models/user_model.dart';

class AuthDataException implements Exception {
  final String message;

  const AuthDataException(this.message);

  @override
  String toString() => 'AuthDataException: $message';
}

class FakeAuthDataSource {
  static const String _defaultOtp = '123456';
  final Map<String, UserModel> _users = {};

  final Map<String, String> _pendingOtps = {};

  // Store phone numbers that have passed OTP verification.
  final Set<String> _verifiedPhones = {};

  Future<void> sendOtp({required String phoneNumber}) async {
    final phone = phoneNumber.trim();

    if (phone.isEmpty) {
      throw const AuthDataException('Phone number is required.');
    }

    // Simulate sending OTP
    _pendingOtps[phone] = _defaultOtp;
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final phone = phoneNumber.trim();

    _verifyOtp(phone, otp);

    // OTP is valid. Mark this phone as verified.
    _verifiedPhones.add(phone);

    // OTP can no longer be reused.
    _pendingOtps.remove(phone);
  }

  Future<UserModel> completeRegistration({
    required String phoneNumber,
    required String firstName,
    String? lastName,
    required DateTime dateOfBirth,
  }) async {
    final phone = phoneNumber.trim();

    if (!_verifiedPhones.contains(phone)) {
      throw const AuthDataException('Please verify your phone number first.');
    }

    if (_users.containsKey(phone)) {
      throw const AuthDataException('Phone number is already registered.');
    }

    if (firstName.trim().isEmpty) {
      throw const AuthDataException('First name is required.');
    }

    final user = UserModel(
      id: 'user-${_users.length + 1}',
      phoneNumber: phone,
      firstName: firstName.trim(),
      lastName: lastName?.trim() ?? '',
      dateOfBirth: dateOfBirth,
    );

    _users[phone] = user;

    // Clear temporary verification state after registration.
    _verifiedPhones.remove(phone);

    return user;
  }

  Future<UserModel> verifyOtpAndLogin({
    required String phoneNumber,
    required String otp,
  }) async {
    final phone = phoneNumber.trim();

    final user = _users[phone];

    if (user == null) {
      throw const AuthDataException('Phone number is not registered.');
    }

    _verifyOtp(phone, otp);
    _pendingOtps.remove(phone);

    return user;
  }

  void _verifyOtp(String phoneNumber, String otp) {
    final expectedOtp = _pendingOtps[phoneNumber];

    if (expectedOtp == null || expectedOtp != otp.trim()) {
      throw const AuthDataException('Invalid or expired OTP.');
    }
  }

  Future<void> logout() async {
    // Session handling will be added later.
  }
}
