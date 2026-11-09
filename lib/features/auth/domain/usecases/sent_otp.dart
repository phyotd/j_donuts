import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/repositories/auth_repository.dart';

class SendOtp {
  final AuthRepository repository;

  SendOtp(this.repository);

  Future<Result<void>> call({required String phoneNumber}) {
    return repository.sendOtp(phoneNumber: phoneNumber);
  }
}
