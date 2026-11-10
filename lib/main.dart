import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:j_donuts/app/router/app_router.dart';
import 'package:j_donuts/app/theme/app_theme.dart';
import 'package:j_donuts/core/database/app_initializer.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialization = ref.watch(appInitializerProvider);

    return initialization.when(
      data: (_) {
        return MaterialApp.router(
          title: 'J Donuts',
          theme: AppTheme.lightTheme,
          routerConfig: appRouter,
        );
      },
      loading: () => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: AppTheme.lightTheme,
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error initializing app: $error')),
        ),
      ),
    );
  }
}
