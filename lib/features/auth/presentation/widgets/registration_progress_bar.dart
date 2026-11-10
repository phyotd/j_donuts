import 'package:flutter/material.dart';

class RegistrationProgressBar extends StatelessWidget {
  final double progress;

  const RegistrationProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 8,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
    );
  }
}
