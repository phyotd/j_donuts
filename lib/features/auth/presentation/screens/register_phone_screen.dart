// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:j_donuts/app/theme/app_colors.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:j_donuts/features/auth/presentation/providers/auth_notifier.dart';
import 'package:j_donuts/features/auth/presentation/widgets/registration_progress_bar.dart';

class RegisterPhoneScreen extends ConsumerStatefulWidget {
  const RegisterPhoneScreen({super.key});

  @override
  ConsumerState<RegisterPhoneScreen> createState() =>
      _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends ConsumerState<RegisterPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = _phoneController.text.trim();

    setState(() {
      _isLoading = true;
    });

    final result = await ref
        .read(authNotifierProvider.notifier)
        .sendOtp(phoneNumber: phoneNumber);

    setState(() {
      _isLoading = false;
    });

    if (result is Success<void>) {
      context.goNamed(
        'verifyOtp',
        pathParameters: {'phoneNumber': phoneNumber},
      );
    } else if (result is Error<void>) {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Progress indicator
                RegistrationProgressBar(progress: 0.25),
                const SizedBox(height: 48),
                const Center(
                  child: Icon(
                    Icons.cake_outlined,
                    size: 64,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    "Welcome to J'Donuts!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    'Enter your phone number to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                const Text(
                  'Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    prefix: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: const Text(
                        '+95',
                        style: TextStyle(
                          color: AppColors.chocolate,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }

                    if (!RegExp(r'^[0-9]{8,10}$').hasMatch(value.trim())) {
                      return 'Please enter a valid phone number';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onContinue,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Continue',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'By continuing, you agree to our Terms & Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
