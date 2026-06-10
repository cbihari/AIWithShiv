import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/auth_service.dart';
import '../data/firebase_auth_repository.dart';
import '../domain/auth_repository.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(ref.watch(authServiceProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser?.uid;
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
