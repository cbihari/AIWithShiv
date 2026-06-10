import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/app_exception.dart';
import 'auth_service.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository(this._service);

  final AuthService _service;

  @override
  Stream<User?> authStateChanges() => _service.authStateChanges();

  @override
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return _service.signInWithEmail(email, password);
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'Unable to sign in.',
        code: error.code,
      );
    }
  }

  @override
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return _service.signUpWithEmail(email, password);
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'Unable to create account.',
        code: error.code,
      );
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      return _service.signInWithGoogle();
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'Unable to sign in with Google.',
        code: error.code,
      );
    }
  }

  @override
  Future<UserCredential> signInWithApple() async {
    try {
      return _service.signInWithApple();
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'Unable to sign in with Apple.',
        code: error.code,
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _service.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (error) {
      throw AuthException(
        error.message ?? 'Unable to send password reset.',
        code: error.code,
      );
    }
  }

  @override
  Future<void> signOut() => _service.signOut();
}
