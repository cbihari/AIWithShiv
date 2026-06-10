import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/presentation/achievement_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/ai_chat/presentation/ai_buddy_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/lessons/presentation/learning_path_screen.dart';
import '../../features/lessons/presentation/lesson_screen.dart';
import '../../features/onboarding/presentation/age_selection_screen.dart';
import '../../features/onboarding/presentation/parent_consent_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/parents/presentation/parent_dashboard_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/quizzes/presentation/quiz_screen.dart';
import '../di/providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
    redirect: (context, state) {
      final publicRoutes = {
        '/',
        '/welcome',
        '/age',
        '/consent',
        '/login',
        '/signup',
      };
      final location = state.uri.path;
      final isPublic = publicRoutes.contains(location);
      final isSignedIn = auth.currentUser != null;
      if (!isSignedIn && !isPublic) return '/login';
      if (isSignedIn && (location == '/login' || location == '/signup')) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/age',
        builder: (context, state) => const AgeSelectionScreen(),
      ),
      GoRoute(
        path: '/consent',
        builder: (context, state) => const ParentConsentScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/learning-path',
        builder: (context, state) => const LearningPathScreen(),
      ),
      GoRoute(
        path: '/lesson/:id',
        builder: (context, state) =>
            LessonScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
      GoRoute(
        path: '/quiz/:lessonId',
        builder: (context, state) =>
            QuizScreen(lessonId: state.pathParameters['lessonId']!),
      ),
      GoRoute(
        path: '/ai-buddy',
        builder: (context, state) => const AiBuddyScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/parents',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
