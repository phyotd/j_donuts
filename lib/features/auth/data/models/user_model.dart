import 'package:j_donuts/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final String firstName;
  final String? lastName;
  final DateTime dateOfBirth;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    this.lastName,
    required this.dateOfBirth,
  });

  User toEntity() {
    return User(
      id: id,
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
    );
  }
}
