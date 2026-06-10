import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/env.dart';
import 'config/firebase_options.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final isProd = Env.environment == 'prod';
  const webRecaptchaSiteKey = String.fromEnvironment(
    'FIREBASE_APP_CHECK_RECAPTCHA_SITE_KEY',
  );
  if (!kIsWeb || webRecaptchaSiteKey.isNotEmpty) {
    await FirebaseAppCheck.instance.activate(
      webProvider: kIsWeb ? ReCaptchaV3Provider(webRecaptchaSiteKey) : null,
      androidProvider:
          isProd ? AndroidProvider.playIntegrity : AndroidProvider.debug,
      appleProvider: isProd ? AppleProvider.appAttest : AppleProvider.debug,
    );
  }
  runApp(const ProviderScope(child: AIWithShivApp()));
}

class AIWithShivApp extends ConsumerWidget {
  const AIWithShivApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'AIWithShiv',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
