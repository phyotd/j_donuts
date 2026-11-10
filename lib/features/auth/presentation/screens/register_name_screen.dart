import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:j_donuts/features/auth/presentation/providers/auth_notifier.dart';
import 'package:j_donuts/features/auth/presentation/screens/register_dob_screen.dart';
import 'package:j_donuts/features/auth/presentation/widgets/registration_progress_bar.dart';

class RegisterNameScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const RegisterNameScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<RegisterNameScreen> createState() => _RegisterNameScreenState();
}

class _RegisterNameScreenState extends ConsumerState<RegisterNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterDobScreen(
          phoneNumber: widget.phoneNumber,
          firstName: firstName,
          lastName: lastName,
          onRegister:
              ({
                required String phoneNumber,
                required String firstName,
                required String lastName,
                required DateTime dateOfBirth,
              }) async {
                // Implement the registration logic here
                return ref
                    .read(authNotifierProvider.notifier)
                    .register(
                      phoneNumber: phoneNumber,
                      dateOfBirth: dateOfBirth,
                      firstName: firstName,
                      lastName: lastName,
                    );
              },
        ),
      ),
    );

    debugPrint('First name: $firstName');
    debugPrint('Last name: $lastName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [RegistrationProgressBar(progress: 0.75)],
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
                        'What is your name?',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Please enter your first and last name.',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'First Name',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _firstNameController,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Enter your first name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your first name';
                          }

                          if (value.trim().length > 50) {
                            return 'First name must not exceed 50 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Last Name (Optional)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _lastNameController,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Enter your last name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.trim().length > 50) {
                            return 'Last name must not exceed 50 characters';
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
                      onPressed: _onContinue,
                      child: const Text(
                        'Continue',
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
