import 'package:flutter_test/flutter_test.dart';
import 'package:mental_zen/features/auth/domain/auth_exceptions.dart';
import 'package:mental_zen/features/auth/domain/auth_validators.dart';
import 'package:mental_zen/features/auth/domain/user_entity.dart';

void main() {
  group('Auth Domain - UserEntity', () {
    test('Happy path: instantiates UserEntity with required fields', () {
      const user = UserEntity(
        uid: 'user_123',
        email: 'student@example.edu',
        displayName: 'Student Tester',
      );

      expect(user.uid, equals('user_123'));
      expect(user.email, equals('student@example.edu'));
      expect(user.displayName, equals('Student Tester'));
    });
  });

  group('Auth Domain - Validators', () {
    test('Happy path: valid email and password return null (no error)', () {
      expect(AuthValidators.validateEmail('user@domain.com'), isNull);
      expect(AuthValidators.validatePassword('validpass123'), isNull);
    });

    test(
      'Invalid input: malformed or empty email returns validation error string',
      () {
        expect(
          AuthValidators.validateEmail(''),
          equals('Email cannot be empty'),
        );
        expect(
          AuthValidators.validateEmail('invalid-email'),
          equals('Please enter a valid email address'),
        );
        expect(
          AuthValidators.validateEmail('test@'),
          equals('Please enter a valid email address'),
        );
      },
    );

    test('Boundary: password with exactly 6 characters succeeds; 5 characters fails', () {
      // 6 chars is the Firebase Auth minimum requirement
      expect(AuthValidators.validatePassword('123456'), isNull);
      expect(
        AuthValidators.validatePassword('12345'),
        equals('Password must be at least 6 characters'),
      );
    });

    test('Failure branch: AuthException maps platform error codes to typed domain exceptions', () {
      final userNotFound = AuthException.fromFirebaseCode('user-not-found');
      expect(userNotFound, isA<UserNotFoundException>());
      expect(userNotFound.message, equals('No account found with this email.'));

      final wrongPassword = AuthException.fromFirebaseCode('wrong-password');
      expect(wrongPassword, isA<InvalidCredentialsException>());
      expect(
        wrongPassword.message,
        equals('Incorrect password. Please try again.'),
      );

      final networkTimeout = AuthException.fromFirebaseCode(
        'network-request-failed',
      );
      expect(networkTimeout, isA<NetworkAuthException>());
      expect(
        networkTimeout.message,
        equals('Network connection lost. Please check your internet.'),
      );

      final unknown = AuthException.fromFirebaseCode('unknown-error');
      expect(unknown, isA<AuthException>());
      expect(
        unknown.message,
        equals('Authentication failed. Please try again.'),
      );
    });
  });
}
