import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegistrationProgressBar(progress: 0.75),

                const SizedBox(height: 40),

                const Text(
                  'What is your name?',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Last Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Enter your last name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
