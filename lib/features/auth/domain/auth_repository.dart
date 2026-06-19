abstract interface class AuthRepository {
  Stream<Object?> authStateChanges();
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}
