class User {
  final String id;
  final String phoneNumber;
  final String firstName;
  final String? lastName;
  final DateTime dateOfBirth;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    this.lastName,
    required this.dateOfBirth,
  });
}
