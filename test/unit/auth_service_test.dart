import 'package:flutter_test/flutter_test.dart';
import 'package:foldious/features/authentication/login_screen/auth_service.dart';

void main() {
  group('AuthRepo Tests', () {
    late AuthRepo authRepo;

    setUp(() {
      authRepo = AuthRepo();
    });

    group('generateNonce', () {
      test('should generate nonce with default length of 32', () {
        final nonce = authRepo.generateNonce();
        expect(nonce.length, equals(32));
      });

      test('should generate nonce with custom length', () {
        final nonce = authRepo.generateNonce(16);
        expect(nonce.length, equals(16));
      });

      test('should generate different nonces on multiple calls', () {
        final nonce1 = authRepo.generateNonce();
        final nonce2 = authRepo.generateNonce();
        expect(nonce1, isNot(equals(nonce2)));
      });

      test('should only contain valid characters', () {
        final nonce = authRepo.generateNonce();
        final validChars = RegExp(r'^[0-9A-Za-z\-._]+$');
        expect(validChars.hasMatch(nonce), isTrue);
      });

      test('should handle zero length gracefully', () {
        final nonce = authRepo.generateNonce(0);
        expect(nonce.length, equals(0));
      });
    });
  });
}
