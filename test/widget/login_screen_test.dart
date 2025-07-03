import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foldious/features/authentication/login_screen/login_controller.dart';
import 'package:foldious/features/authentication/login_screen/login_screen.dart';
import 'package:get/get.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late LoginController loginController;

    setUp(() {
      loginController = LoginController();
      Get.put(loginController);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('should display login screen with all elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Verify main elements are present
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Enter your email and password'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should have email and password text fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Find text fields by their labels
      expect(find.byType(TextField), findsAtLeast(2));

      // Verify placeholder texts
      expect(find.text('Your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('should show login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should navigate to forgot password screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Tap on forgot password button
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('should navigate to signup screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Tap on sign up button
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('should show social login buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Verify social login buttons are present
      expect(find.text('Sign in with Google'), findsOneWidget);

      // Apple sign-in should be present on iOS
      // Note: This test might need adjustment based on platform
    });

    testWidgets('should handle text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Enter email
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.pump();

      // Enter password
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should unfocus when tapping outside',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Focus on email field
      await tester.tap(find.byType(TextField).first);
      await tester.pump();

      // Tap outside to unfocus
      await tester.tapAt(const Offset(100, 100));
      await tester.pump();

      // Verify focus is lost
      expect(FocusScope.of(tester.element(find.byType(LoginScreen))).hasFocus,
          isFalse);
    });

    testWidgets('should show loading indicator when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Initially no loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Set loading to true
      loginController.isLoading.value = true;
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
