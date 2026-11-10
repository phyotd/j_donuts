import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool _isLoading = false;
  bool _isResending = false;

  int _wrongAttempts = 0;
  String? _errorMessage;

  bool get _isLocked => _wrongAttempts >= 3;

  bool get _isOtpComplete => _otpController.text.trim().length == 6;

  Timer? _resendTimer;

  int _resendCountdown = 300;

  String get _resendTime {
    final minutes = (_resendCountdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendCountdown % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 8, end: -4), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();

    setState(() {
      _resendCountdown = 300;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();

        setState(() {
          _resendCountdown = 0;
        });
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    setState(() {
      if (value.isNotEmpty) {
        _errorMessage = null;
      }
    });
  }

  Future<void> _onVerify() async {
    if (_isLoading || _isLocked || !_isOtpComplete) return;

    final otp = _otpController.text.trim();

    if (otp != '123456') {
      setState(() {
        _wrongAttempts++;
        _errorMessage = _isLocked
            ? 'Too many incorrect attempts. Please resend OTP.'
            : 'Incorrect OTP. Please try again.';
      });

      _otpController.clear();

      await _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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

  Future<void> _onResendOtp() async {
    if (_isResending || _isLoading || _resendCountdown > 0) return;

    setState(() {
      _isResending = true;
    });

    final result = await ref
        .read(authNotifierProvider.notifier)
        .sendOtp(phoneNumber: widget.phoneNumber);

    if (!mounted) return;

    setState(() {
      _isResending = false;
    });

    if (result is Success<void>) {
      setState(() {
        _wrongAttempts = 0;
        _errorMessage = null;
        _otpController.clear();
      });

      _startResendCountdown();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('A new OTP has been sent.')));
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [RegistrationProgressBar(progress: 0.5)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  widget.phoneNumber,
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

                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: TextFormField(
                    controller: _otpController,
                    onChanged: _onOtpChanged,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
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
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],

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
                    onPressed:
                        _isResending || _isLoading || _resendCountdown > 0
                        ? null
                        : _onResendOtp,
                    child: _isResending
                        ? const CircularProgressIndicator()
                        : Text(
                            _resendCountdown > 0
                                ? 'Resend OTP in $_resendTime'
                                : 'Resend OTP',
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
