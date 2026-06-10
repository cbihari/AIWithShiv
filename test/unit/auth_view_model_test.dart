import 'package:aiwithshiv/features/auth/domain/auth_repository.dart';
import 'package:aiwithshiv/features/auth/presentation/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  var signInCalled = false;

  @override
  Stream<User?> authStateChanges() => const Stream.empty();

  @override
  Future<UserCredential> signIn(String email, String password) async {
    signInCalled = true;
    throw UnimplementedError(
      'UserCredential is supplied by Firebase in integration tests.',
    );
  }

  @override
  Future<UserCredential> signUp(String email, String password) =>
      signIn(email, password);

  @override
  Future<UserCredential> signInWithGoogle() => signIn('google', 'google');

  @override
  Future<UserCredential> signInWithApple() => signIn('apple', 'apple');

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  test('AuthViewModel reports errors through AsyncValue', () async {
    final repository = FakeAuthRepository();
    final viewModel = AuthViewModel(repository);

    await viewModel.signIn('learner@example.com', 'secret');

    expect(repository.signInCalled, isTrue);
    expect(viewModel.state, isA<AsyncError<void>>());
  });
}
