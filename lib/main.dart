import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/ads/ad_service.dart';
import 'core/constants/app_constants.dart';
import 'core/localization/language_service.dart';
import 'core/routing/app_router.dart';
import 'core/services/accessibility_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/content_cache_service.dart';
import 'core/services/tts_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AccessibilityService.instance.load();
  await LanguageService.instance.load();
  await AdService.instance.initialize();
  await const ContentCacheService().warmCache();
  runApp(const ProviderScope(child: AIWithShivApp()));
}

class AIWithShivApp extends ConsumerStatefulWidget {
  const AIWithShivApp({super.key});

  @override
  ConsumerState<AIWithShivApp> createState() => _AIWithShivAppState();
}

class _AIWithShivAppState extends ConsumerState<AIWithShivApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await TtsService.instance.initialize();
      final prefs = await SharedPreferences.getInstance();
      await AnalyticsService.instance.appOpened(
        ageGroup: prefs.getString('age_group') ?? 'unknown',
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshCacheIfStale();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return ValueListenableBuilder<AccessibilitySettings>(
      valueListenable: AccessibilityService.settings,
      builder: (context, settings, child) =>
          ValueListenableBuilder<AppLanguage>(
        valueListenable: LanguageService.language,
        builder: (context, language, child) => MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          locale: language.locale,
          supportedLocales: const [Locale('en'), Locale('hi')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: AppTheme.lightFor(easyReading: settings.easyReading),
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: router,
        ),
      ),
    );
  }

  Future<void> _refreshCacheIfStale() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_timestamp');
    final timestamp = raw == null ? null : DateTime.tryParse(raw);
    final stale = timestamp == null ||
        DateTime.now().difference(timestamp) > const Duration(hours: 1);
    if (stale) await const ContentCacheService().warmCache();
  }
}
