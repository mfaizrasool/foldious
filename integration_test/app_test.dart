import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foldious/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should show splash screen on app start',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to login screen after splash',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash to complete and navigate to login
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify login screen elements are present
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should handle form validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Try to login without entering credentials
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Should show validation errors or stay on login screen
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should navigate to forgot password screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Tap forgot password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Should navigate to forgot password screen
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('should navigate to signup screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Tap sign up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Should navigate to signup screen
      expect(find.text('Login'), findsNothing);
    });
  });
}
