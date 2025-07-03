# Testing Guide for Foldious

This directory contains comprehensive tests for the Foldious cloud storage app.

## Test Structure

```
test/
├── unit/                    # Unit tests for business logic
│   ├── auth_service_test.dart
│   └── error_handler_test.dart
├── widget/                  # Widget tests for UI components
│   └── login_screen_test.dart
├── integration_test/        # Integration tests for app flows
│   └── app_test.dart
├── test_runner.dart         # Test runner script
└── README.md               # This file
```

## Running Tests

### Unit Tests
```bash
flutter test test/unit/
```

### Widget Tests
```bash
flutter test test/widget/
```

### Integration Tests
```bash
flutter test integration_test/
```

### All Tests
```bash
flutter test
```

### With Coverage
```bash
flutter test --coverage
```

## Test Categories

### 1. Unit Tests
- **Purpose**: Test individual functions and classes in isolation
- **Location**: `test/unit/`
- **Examples**: 
  - Authentication service methods
  - Error handling utilities
  - Data models and parsing

### 2. Widget Tests
- **Purpose**: Test UI components and user interactions
- **Location**: `test/widget/`
- **Examples**:
  - Login screen form validation
  - Button interactions
  - Navigation flows

### 3. Integration Tests
- **Purpose**: Test complete app flows and user journeys
- **Location**: `integration_test/`
- **Examples**:
  - Complete login flow
  - File upload process
  - Navigation between screens

## Testing Best Practices

### 1. Test Naming
- Use descriptive test names that explain what is being tested
- Follow the pattern: `should [expected behavior] when [condition]`

### 2. Test Organization
- Group related tests using `group()`
- Use `setUp()` and `tearDown()` for common test setup
- Keep tests independent and isolated

### 3. Mocking
- Use mocks for external dependencies (APIs, databases, etc.)
- Generate mocks using `build_runner`:
  ```bash
  flutter packages pub run build_runner build
  ```

### 4. Error Testing
- Test both success and failure scenarios
- Verify error messages and handling
- Test edge cases and boundary conditions

## Adding New Tests

### 1. Unit Test
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_package/your_file.dart';

void main() {
  group('YourClass Tests', () {
    test('should do something when condition', () {
      // Arrange
      final instance = YourClass();
      
      // Act
      final result = instance.method();
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### 2. Widget Test
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_package/your_widget.dart';

void main() {
  group('YourWidget Tests', () {
    testWidgets('should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(YourWidget());
      
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

## Continuous Integration

Tests are automatically run in CI/CD pipelines to ensure code quality. Make sure all tests pass before merging code.

## Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: Cover critical user flows

## Troubleshooting

### Common Issues

1. **Mock Generation Fails**
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build
   ```

2. **Tests Fail Due to Dependencies**
   ```bash
   flutter clean
   flutter pub get
   flutter test
   ```

3. **Integration Tests Fail**
   - Ensure device/emulator is running
   - Check that app can be launched successfully
   - Verify all required permissions are granted

### Getting Help

- Check the Flutter testing documentation
- Review existing tests for patterns
- Ask the team for guidance on complex test scenarios 