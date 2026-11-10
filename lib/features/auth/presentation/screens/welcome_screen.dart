import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:j_donuts/app/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  final String firstName;

  const WelcomeScreen({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/donuts/bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.35),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),

                  const Icon(
                    Icons.celebration,
                    size: 100,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Welcome, $firstName!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Your J Donuts account has been created successfully. '
                    'We are excited to have you as a member!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
