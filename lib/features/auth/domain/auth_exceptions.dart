class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, [this.code]);

  factory AuthException.fromFirebaseCode(String code) {
    switch (code) {
      case 'user-not-found':
        return const UserNotFoundException(
          'No account found with this email.',
          'user-not-found',
        );
      case 'wrong-password':
      case 'invalid-credential':
        return const InvalidCredentialsException(
          'Incorrect password. Please try again.',
          'wrong-password',
        );
      case 'network-request-failed':
        return const NetworkAuthException(
          'Network connection lost. Please check your internet.',
          'network-request-failed',
        );
      case 'email-already-in-use':
        return const AuthException(
          'An account already exists for this email.',
          'email-already-in-use',
        );
      case 'weak-password':
        return const WeakPasswordException(
          'The password provided is too weak.',
          'weak-password',
        );
      default:
        return AuthException('Authentication failed. Please try again.', code);
    }
  }

  @override
  String toString() => message;
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException(super.message, [super.code]);
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException(super.message, [super.code]);
}

class NetworkAuthException extends AuthException {
  const NetworkAuthException(super.message, [super.code]);
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException(super.message, [super.code]);
}
