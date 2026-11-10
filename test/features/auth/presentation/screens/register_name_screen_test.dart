import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:j_donuts/features/auth/presentation/screens/register_name_screen.dart';
import 'package:j_donuts/features/auth/presentation/screens/register_dob_screen.dart';

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      child: MaterialApp(home: RegisterNameScreen(phoneNumber: '912345678')),
    );
  }

  group('RegisterNameScreen Widget Tests', () {
    testWidgets('should display name input fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('What is your name?'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name (Optional)'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should show error when first name is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your first name'), findsOneWidget);
    });

    testWidgets('should allow empty last name', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'Phyo');

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(
        find.text('Last name must not exceed 15 characters'),
        findsNothing,
      );

      expect(find.byType(RegisterDobScreen), findsOneWidget);
    });

    testWidgets('should accept first name with 15 characters', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'ABCDEFGHIJKLMNO',
      );

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterDobScreen), findsOneWidget);
    });

    testWidgets('should accept last name with 15 characters', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'Phyo');
      await tester.enterText(fields.at(1), 'ABCDEFGHIJKLMNO');

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterDobScreen), findsOneWidget);
    });
  });
}
