import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepo {
  Future<firebaseAuth.UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce(); // Generate a secure nonce
      final nonce = _sha256ofString(rawNonce); // Hash the nonce

      // Log nonce information for debugging
      print('rawNonce: $rawNonce');
      print('hashedNonce: $nonce');

      // Get Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce, // Pass the hashed nonce
      );

      // Log Apple credential information for debugging
      print("appleCredential identityToken: ${appleCredential.identityToken}");
      print(
          "appleCredential authorizationCode: ${appleCredential.authorizationCode}");

      // Check for null tokens and print a message if any are null
      if (appleCredential.identityToken == null) {
        print('Error: identityToken is null');
      }

      // Create an OAuth credential with Apple ID token
      final oauthCredential =
          firebaseAuth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce, // Pass the raw nonce (before hashing)
      );

      // Sign in to Firebase using the OAuth credential
      final userCredential = await firebaseAuth.FirebaseAuth.instance
          .signInWithCredential(oauthCredential);
      print('UserCredential: ${userCredential.toString()}');

      // Check and update user's display name if null or empty
      if (userCredential.user?.displayName == null ||
          (userCredential.user?.displayName != null &&
              userCredential.user!.displayName!.isEmpty)) {
        final fixDisplayNameFromApple = [
          appleCredential.givenName ?? '',
          appleCredential.familyName ?? '',
        ].join(' ').trim();
        await userCredential.user?.updateDisplayName(fixDisplayNameFromApple);
        await userCredential.user?.reload();
      }
      print('Updated UserCredential: ${userCredential.toString()}');
      return userCredential;
    } on firebaseAuth.FirebaseAuthException catch (exception) {
      print(
          'Firebase Auth Exception in Sign In with Apple: ${exception.message}');
      throw exception;
    } catch (e) {
      print('Error during Sign In with Apple: $e');
      return null;
    }
  }

  // Helper function to hash the nonce using SHA-256
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input); // Convert the input to bytes
    final digest = sha256.convert(bytes); // Hash the bytes using SHA-256
    return digest.toString(); // Return the hashed string
  }

  // Function to generate a secure random nonce of a given length
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
}
