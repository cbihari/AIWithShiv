import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRepository {
  Stream<User?> authStateChanges();
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signUp(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}
