import 'package:go_router/go_router.dart';
import 'package:j_donuts/features/auth/presentation/screens/register_name_screen.dart';
import 'package:j_donuts/features/auth/presentation/screens/register_phone_screen.dart';
import 'package:j_donuts/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:j_donuts/features/home/presentation/screens/home_screen.dart';
import 'package:j_donuts/features/onboarding/presentation/screens/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/phone',
      name: 'phone',
      builder: (context, state) => const RegisterPhoneScreen(),
    ),
    GoRoute(
      path: '/verify-otp/:phoneNumber',
      name: 'verifyOtp',
      builder: (context, state) {
        final phoneNumber = state.pathParameters['phoneNumber']!;

        return VerifyOtpScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/name/:phoneNumber',
      name: 'name',
      builder: (context, state) {
        final phoneNumber = state.pathParameters['phoneNumber']!;

        return RegisterNameScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // GoRoute(
    //   path: '/rewards',
    //   name: 'reward',
    //   builder: (context, state) => const RewardsScreen(),
    // ),
  ],
);
