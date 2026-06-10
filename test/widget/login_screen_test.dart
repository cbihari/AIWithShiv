import 'package:aiwithshiv/features/auth/domain/auth_repository.dart';
import 'package:aiwithshiv/features/auth/presentation/auth_providers.dart';
import 'package:aiwithshiv/features/auth/presentation/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<User?> authStateChanges() => const Stream.empty();

  @override
  Future<UserCredential> signIn(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signUp(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets(
    'Login screen exposes email, password, and social login actions',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
      expect(find.text('Reset password'), findsOneWidget);
    },
  );
}
