import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return const DisabledAuthRepository();
});

final authStateProvider = StreamProvider<Object?>((ref) {
  return Stream<Object?>.value(null);
});

final currentUserIdProvider = Provider<String?>((ref) {
  return 'local-child';
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  return AuthViewModel(ref.watch(authRepositoryProvider));
});

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  AuthViewModel(this._repository) : super(const AsyncData(null));

  final AuthRepository _repository;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signIn(email.trim(), password),
    );
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signUp(email.trim(), password),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signInWithGoogle);
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signInWithApple);
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.sendPasswordResetEmail(email.trim()),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signOut);
  }
}

class DisabledAuthRepository implements AuthRepository {
  const DisabledAuthRepository();

  @override
  Stream<Object?> authStateChanges() => Stream<Object?>.value(null);

  @override
  Future<void> signIn(String email, String password) => _disabled();

  @override
  Future<void> signUp(String email, String password) => _disabled();

  @override
  Future<void> signInWithApple() => _disabled();

  @override
  Future<void> signInWithGoogle() => _disabled();

  @override
  Future<void> sendPasswordResetEmail(String email) => _disabled();

  @override
  Future<void> signOut() async {}

  Never _disabled() {
    throw const AuthException(
      'Login is disabled in the local-first mobile app.',
      code: 'auth_disabled',
    );
  }
}
