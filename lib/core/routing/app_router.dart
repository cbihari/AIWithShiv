import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/presentation/achievement_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/games/presentation/games_screen.dart';
import '../../features/lessons/presentation/learning_path_screen.dart';
import '../../features/lessons/presentation/lesson_screen.dart';
import '../../features/onboarding/presentation/age_selection_screen.dart';
import '../../features/onboarding/presentation/hero_setup_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/quizzes/presentation/quiz_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../screens/ai_buddy_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.uri.path;
      if (location == '/login' ||
          location == '/signup' ||
          location == '/consent' ||
          location == '/parents' ||
          location == '/admin') {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) =>
            _slidePage(state, const WelcomeScreen()),
      ),
      GoRoute(
        path: '/age',
        pageBuilder: (context, state) =>
            _slidePage(state, const AgeSelectionScreen()),
      ),
      GoRoute(
        path: '/hero-setup',
        pageBuilder: (context, state) =>
            _slidePage(state, const HeroSetupScreen()),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) =>
            _fadeScalePage(state, const DashboardScreen()),
      ),
      GoRoute(
        path: '/learning-path',
        pageBuilder: (context, state) =>
            _slidePage(state, const LearningPathScreen()),
      ),
      GoRoute(
        path: '/lesson/:id',
        pageBuilder: (context, state) => _scalePage(
          state,
          LessonScreen(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/quiz',
        pageBuilder: (context, state) =>
            _slideUpPage(state, const QuizScreen()),
      ),
      GoRoute(
        path: '/quiz/:lessonId',
        pageBuilder: (context, state) => _slideUpPage(
          state,
          QuizScreen(lessonId: state.pathParameters['lessonId']!),
        ),
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
        path: '/shop',
        pageBuilder: (context, state) =>
            _slideUpPage(state, const ShopScreen()),
      ),
      GoRoute(
        path: '/games',
        pageBuilder: (context, state) => _slidePage(state, const GamesScreen()),
      ),
      GoRoute(
        path: '/games/train-robot',
        pageBuilder: (context, state) => _scalePage(
          state,
          const GameDetailScreen(gameId: 'train_robot'),
        ),
      ),
      GoRoute(
        path: '/games/ai-detective',
        pageBuilder: (context, state) => _scalePage(
          state,
          const GameDetailScreen(gameId: 'ai_detective'),
        ),
      ),
      GoRoute(
        path: '/games/sort-like-ai',
        pageBuilder: (context, state) => _scalePage(
          state,
          const GameDetailScreen(gameId: 'sort_like_ai'),
        ),
      ),
      GoRoute(
        path: '/games/robot-treasure-hunt',
        pageBuilder: (context, state) => _scalePage(
          state,
          const GameDetailScreen(gameId: 'robot_treasure_hunt'),
        ),
      ),
      GoRoute(
        path: '/games/spot-ai-mistake',
        pageBuilder: (context, state) => _scalePage(
          state,
          const GameDetailScreen(gameId: 'spot_ai_mistake'),
        ),
      ),
    ],
  );
});

CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);
      return SlideTransition(position: offset, child: child);
    },
  );
}

CustomTransitionPage<void> _slideUpPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
      return SlideTransition(position: offset, child: child);
    },
  );
}

CustomTransitionPage<void> _scalePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

CustomTransitionPage<void> _fadeScalePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(animation),
          child: child,
        ),
      );
    },
  );
}
