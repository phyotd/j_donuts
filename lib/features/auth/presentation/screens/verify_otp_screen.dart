import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:go_router/go_router.dart';
import 'package:j_donuts/features/auth/presentation/providers/auth_notifier.dart';
import 'package:j_donuts/features/auth/domain/entities/user.dart' as auth;
import 'package:j_donuts/features/auth/presentation/widgets/registration_progress_bar.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const VerifyOtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(
          phoneNumber: widget.phoneNumber,
          otp: _otpController.text.trim(),
        );

    if (!mounted) return;

    setState(() => _isLoading = false);
    if (result is Success<auth.User?>) {
      final user = (result).data;
      if (user == null) {
        // New user → Name screen
        context.goNamed(
          'name',
          pathParameters: {'phoneNumber': widget.phoneNumber},
        );
      } else {
        context.goNamed('home');
      }
    } else if (result is Error<auth.User?>) {
      final failure = (result).failure;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone Number')),
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
                RegistrationProgressBar(progress: 0.50),

                const SizedBox(height: 40),

                const Text(
                  'Verify Your Phone',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const Text(
                  'We have sent a 6-digit verification code to:',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 8),

                Text(
                  '+95 ${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Enter OTP Code',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '------',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the OTP code';
                    }

                    if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
                      return 'OTP must contain exactly 6 digits';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onVerify,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement resend OTP.
                    },
                    child: const Text('Resend OTP'),
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
