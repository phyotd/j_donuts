class AuthDataException implements Exception {
  final String message;

  const AuthDataException(this.message);

  @override
  String toString() => 'AuthDataException: $message';
}

class FakeAuthDataSource {
  static const String _defaultOtp = '123456';
  // final Map<String, UserModel> _users = {};

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

  // Check and consume registration verification.
  bool consumeVerifiedPhone({required String phoneNumber}) {
    return _verifiedPhones.remove(phoneNumber.trim());
  }

  void _verifyOtp(String phoneNumber, String otp) {
    final expectedOtp = _pendingOtps[phoneNumber];

    if (expectedOtp == null || expectedOtp != otp.trim()) {
      throw const AuthDataException('Invalid or expired OTP.');
    }
  }
}
