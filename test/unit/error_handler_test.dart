import 'package:flutter_test/flutter_test.dart';
import 'package:foldious/utils/error_handler.dart';

void main() {
  group('ErrorHandler Tests', () {
    group('AppException', () {
      test('should create AppException with all parameters', () {
        final exception = AppException(
          message: 'Test error',
          code: 'TEST_001',
          type: ErrorType.network,
          originalError: 'Original error',
        );

        expect(exception.message, equals('Test error'));
        expect(exception.code, equals('TEST_001'));
        expect(exception.type, equals(ErrorType.network));
        expect(exception.originalError, equals('Original error'));
      });

      test('should return correct string representation', () {
        final exception = AppException(
          message: 'Test error',
          code: 'TEST_001',
          type: ErrorType.network,
        );

        final stringRep = exception.toString();
        expect(stringRep, contains('AppException'));
        expect(stringRep, contains('Test error'));
        expect(stringRep, contains('network'));
        expect(stringRep, contains('TEST_001'));
      });
    });

    group('ErrorHandler static methods', () {
      test('should create network error', () {
        final error = ErrorHandler.networkError('Network failed');
        expect(error.type, equals(ErrorType.network));
        expect(error.message, equals('Network failed'));
      });

      test('should create authentication error', () {
        final error = ErrorHandler.authenticationError('Auth failed');
        expect(error.type, equals(ErrorType.authentication));
        expect(error.message, equals('Auth failed'));
      });

      test('should create validation error', () {
        final error = ErrorHandler.validationError('Invalid input');
        expect(error.type, equals(ErrorType.validation));
        expect(error.message, equals('Invalid input'));
      });

      test('should create server error', () {
        final error = ErrorHandler.serverError('Server error');
        expect(error.type, equals(ErrorType.server));
        expect(error.message, equals('Server error'));
      });

      test('should create permission error', () {
        final error = ErrorHandler.permissionError('Permission denied');
        expect(error.type, equals(ErrorType.permission));
        expect(error.message, equals('Permission denied'));
      });

      test('should create file error', () {
        final error = ErrorHandler.fileError('File operation failed');
        expect(error.type, equals(ErrorType.file));
        expect(error.message, equals('File operation failed'));
      });
    });

    group('ErrorHandler singleton', () {
      test('should return same instance', () {
        final instance1 = ErrorHandler();
        final instance2 = ErrorHandler();
        expect(identical(instance1, instance2), isTrue);
      });
    });
  });
}
