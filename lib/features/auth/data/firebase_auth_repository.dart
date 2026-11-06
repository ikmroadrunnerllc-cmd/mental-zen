import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../domain/auth_exceptions.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({fb.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  UserEntity? _mapFirebaseUser(fb.User? user) {
    if (user == null) return null;
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  UserEntity? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<UserEntity> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        throw const AuthException('User payload empty after authentication.');
      }
      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('An unexpected error occurred during sign in: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        throw const AuthException('User payload empty after registration.');
      }
      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        'An unexpected error occurred during registration: $e',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }
}
