import 'package:flutter/material.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart';
import 'package:j_donuts/features/auth/presentation/widgets/registration_progress_bar.dart';
import 'package:go_router/go_router.dart';

class RegisterDobScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;

  final Future<Result<User>> Function({
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  })
  onRegister;

  const RegisterDobScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.onRegister,
  });

  @override
  State<RegisterDobScreen> createState() => _RegisterDobScreenState();
}

class _RegisterDobScreenState extends State<RegisterDobScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  bool _isLoading = false;

  bool get _isAtLeast13 {
    if (_selectedDate == null) return false;

    final today = DateTime.now();
    final minimumDate = DateTime(today.year - 13, today.month, today.day);

    return !_selectedDate!.isAfter(minimumDate);
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || !_isAtLeast13) return;

    setState(() => _isLoading = true);

    final result = await widget.onRegister(
      phoneNumber: widget.phoneNumber,
      firstName: widget.firstName,
      lastName: widget.lastName,
      dateOfBirth: _selectedDate!,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result is Success<User>) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/home');
    } else if (result is Error<User>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.failure.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [RegistrationProgressBar(progress: 1.0)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      const Text(
                        'What is your date of birth?',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Please select your date of birth.',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),

                      const SizedBox(height: 32),

                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _selectedDate == null
                              ? 'Select your date of birth'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final now = DateTime.now();

                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              now.year - 13,
                              now.month,
                              now.day,
                            ),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(
                              now.year - 13,
                              now.month,
                              now.day,
                            ),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Please select your date of birth';
                          }

                          if (!_isAtLeast13) {
                            return 'You must be at least 13 years old';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onRegister,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'By continuing, you acknowledge that you have read and\n'
                              'agree to our ',
                        ),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
