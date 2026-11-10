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
  final _phoneFocusNode = FocusNode();

  bool _isLoading = false;
  bool _showPhoneError = false;

  @override
  void initState() {
    super.initState();

    _phoneFocusNode.addListener(() {
      setState(() {
        _showPhoneError = !_phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  String _normalizePhoneNumber(String value) {
    String phone = value.replaceAll(RegExp(r'[\s-]'), '');

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    return phone;
  }

  bool get _isPhoneValid {
    final phone = _normalizePhoneNumber(_phoneController.text);
    return RegExp(r'^9[0-9]{7,9}$').hasMatch(phone);
  }

  String get _phoneErrorMessage {
    if (_phoneController.text.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    return 'Please enter a valid Myanmar phone number';
  }

  Future<void> _onContinue() async {
    if (!_isPhoneValid || _isLoading) return;

    final normalizedPhone = _normalizePhoneNumber(_phoneController.text.trim());

    final phoneNumber = '+95$normalizedPhone';

    setState(() {
      _isLoading = true;
    });

    final result = await ref
        .read(authNotifierProvider.notifier)
        .sendOtp(phoneNumber: phoneNumber);

    if (!mounted) return;

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
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneValid = _isPhoneValid;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [RegistrationProgressBar(progress: 0.25)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  focusNode: _phoneFocusNode,
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
                    errorText: _showPhoneError && !isPhoneValid
                        ? _phoneErrorMessage
                        : null,
                  ),
                ),

                const SizedBox(height: 24),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isPhoneValid && !_isLoading ? _onContinue : null,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
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
                        // TODO: Open Terms of Use
                        // onTap: () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        // TODO: Open Privacy Policy
                        // onTap: () {},
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
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
