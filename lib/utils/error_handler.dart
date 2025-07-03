import 'package:flutter/material.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

/// Custom exception class for app-specific errors
class AppException implements Exception {
  final String message;
  final String? code;
  final ErrorType type;
  final dynamic originalError;

  AppException({
    required this.message,
    this.code,
    required this.type,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (Type: $type, Code: $code)';
}

/// Enum to categorize different types of errors
enum ErrorType {
  network,
  authentication,
  validation,
  server,
  permission,
  file,
  unknown,
}

/// Centralized error handling service
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Handle errors and show appropriate user feedback
  void handleError(
    dynamic error, {
    String? customMessage,
    bool showSnackbar = true,
    VoidCallback? onError,
  }) {
    AppException appException = _parseError(error);

    // Log error for debugging
    _logError(appException);

    // Show user-friendly message
    if (showSnackbar) {
      _showUserFriendlyMessage(appException, customMessage);
    }

    // Execute custom error handler if provided
    onError?.call();

    // Handle specific error types
    _handleSpecificError(appException);
  }

  /// Parse different types of errors into AppException
  AppException _parseError(dynamic error) {
    if (error is AppException) {
      return error;
    }

    String message = 'An unexpected error occurred';
    ErrorType type = ErrorType.unknown;
    // String? code;

    if (error is Exception) {
      message = error.toString();

      if (error.toString().contains('network') ||
          error.toString().contains('connection')) {
        type = ErrorType.network;
        message =
            'Network connection error. Please check your internet connection.';
      } else if (error.toString().contains('auth') ||
          error.toString().contains('login')) {
        type = ErrorType.authentication;
        message = 'Authentication failed. Please try logging in again.';
      } else if (error.toString().contains('permission')) {
        type = ErrorType.permission;
        message = 'Permission denied. Please grant the required permissions.';
      } else if (error.toString().contains('file')) {
        type = ErrorType.file;
        message = 'File operation failed. Please try again.';
      }
    }

    return AppException(
      message: message,
      type: type,
      originalError: error,
    );
  }

  /// Log errors for debugging
  void _logError(AppException exception) {
    print('=== ERROR LOG ===');
    print('Type: ${exception.type}');
    print('Message: ${exception.message}');
    print('Code: ${exception.code}');
    print('Original Error: ${exception.originalError}');
    print('================');
  }

  /// Show user-friendly error messages
  void _showUserFriendlyMessage(AppException exception, String? customMessage) {
    String message = customMessage ?? exception.message;

    switch (exception.type) {
      case ErrorType.network:
        showErrorMessage(
          message,
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
      case ErrorType.authentication:
        showErrorMessage(
          message,
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
      case ErrorType.validation:
        showErrorMessage(
          message,
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
      case ErrorType.server:
        showErrorMessage(
          'Server error. Please try again later.',
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
      case ErrorType.permission:
        showErrorMessage(
          message,
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
      case ErrorType.file:
        showErrorMessage(
          message,
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
      case ErrorType.unknown:
        showErrorMessage(
          'Something went wrong. Please try again.',
          messengerState: ScaffoldMessenger.of(Get.context!),
        );
        break;
    }
  }

  /// Handle specific error types with custom logic
  void _handleSpecificError(AppException exception) {
    switch (exception.type) {
      case ErrorType.authentication:
        // Navigate to login screen or refresh token
        _handleAuthenticationError();
        break;
      case ErrorType.network:
        // Show retry options or offline mode
        _handleNetworkError();
        break;
      case ErrorType.permission:
        // Request permissions or show settings
        _handlePermissionError();
        break;
      default:
        break;
    }
  }

  void _handleAuthenticationError() {
    // Navigate to login screen
    Get.offAllNamed('/login');
  }

  void _handleNetworkError() {
    // Could show a retry dialog or enable offline mode
    print('Network error handled');
  }

  void _handlePermissionError() {
    // Could show permission request dialog
    print('Permission error handled');
  }

  /// Create specific error types for common scenarios
  static AppException networkError(String message) {
    return AppException(
      message: message,
      type: ErrorType.network,
    );
  }

  static AppException authenticationError(String message) {
    return AppException(
      message: message,
      type: ErrorType.authentication,
    );
  }

  static AppException validationError(String message) {
    return AppException(
      message: message,
      type: ErrorType.validation,
    );
  }

  static AppException serverError(String message) {
    return AppException(
      message: message,
      type: ErrorType.server,
    );
  }

  static AppException permissionError(String message) {
    return AppException(
      message: message,
      type: ErrorType.permission,
    );
  }

  static AppException fileError(String message) {
    return AppException(
      message: message,
      type: ErrorType.file,
    );
  }
}
