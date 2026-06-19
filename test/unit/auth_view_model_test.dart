import 'package:aiwithshiv/features/auth/domain/auth_repository.dart';
import 'package:aiwithshiv/features/auth/presentation/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  var signInCalled = false;

  @override
  Stream<Object?> authStateChanges() => const Stream.empty();

  @override
  Future<void> signIn(String email, String password) async {
    signInCalled = true;
    throw UnimplementedError('Auth is disabled in local-first mode.');
  }

  @override
  Future<void> signUp(String email, String password) => signIn(email, password);

  @override
  Future<void> signInWithGoogle() => signIn('google', 'google');

  @override
  Future<void> signInWithApple() => signIn('apple', 'apple');

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
