import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/widgets/comic_widgets.dart';

class AppTheme {
  const AppTheme._();

  static const _seed = ComicColors.red;
  static const _safeText = Color(0xFF1A1A1A);

  static ThemeData lightFor({bool easyReading = false}) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
          primary: _seed,
          secondary: ComicColors.yellow,
          tertiary: ComicColors.green,
          error: ComicColors.red,
          surface: easyReading ? Colors.white : ComicColors.cream,
        ),
        scaffoldBackgroundColor: easyReading ? Colors.white : ComicColors.navy,
        textTheme: GoogleFonts.nunitoTextTheme()
            .apply(
              bodyColor: easyReading ? Colors.black : _safeText,
              displayColor: easyReading ? Colors.black : _safeText,
            )
            .copyWith(
              displayLarge: GoogleFonts.bangers(
                letterSpacing: 0,
                color: _safeText,
              ),
              displayMedium: GoogleFonts.bangers(
                letterSpacing: 0,
                color: _safeText,
              ),
              displaySmall: GoogleFonts.bangers(
                letterSpacing: 0,
                color: _safeText,
              ),
              headlineLarge: GoogleFonts.bangers(
                letterSpacing: 0,
                color: _safeText,
              ),
              headlineMedium: GoogleFonts.bangers(
                letterSpacing: 0,
                color: _safeText,
              ),
              headlineSmall: GoogleFonts.bangers(
                letterSpacing: 0,
                color: _safeText,
              ),
              bodyLarge: GoogleFonts.nunito(
                fontSize: easyReading ? 22 : 18,
                height: easyReading ? 1.8 : 1.45,
                color: easyReading ? Colors.black : _safeText,
              ),
              bodyMedium: GoogleFonts.nunito(
                fontSize: easyReading ? 20 : 16,
                height: easyReading ? 1.8 : 1.45,
                color: easyReading ? Colors.black : _safeText,
              ),
              bodySmall: GoogleFonts.nunito(
                fontSize: easyReading ? 20 : 16,
                height: easyReading ? 1.8 : 1.45,
                color: easyReading ? Colors.black : _safeText,
              ),
              titleLarge: GoogleFonts.nunito(
                fontSize: easyReading ? 26 : 22,
                fontWeight: FontWeight.w900,
                color: easyReading ? Colors.black : _safeText,
              ),
              titleMedium: GoogleFonts.nunito(
                fontSize: easyReading ? 22 : 18,
                fontWeight: FontWeight.w900,
                color: easyReading ? Colors.black : _safeText,
              ),
              titleSmall: GoogleFonts.nunito(
                fontSize: easyReading ? 20 : 16,
                fontWeight: FontWeight.w900,
                color: easyReading ? Colors.black : _safeText,
              ),
            ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: ComicColors.cream,
          foregroundColor: ComicColors.ink,
          titleTextStyle: GoogleFonts.bangers(
            color: ComicColors.red,
            fontSize: 30,
            letterSpacing: 0,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: ComicColors.ink, width: 4),
            borderRadius: BorderRadius.circular(20),
          ),
          color: ComicColors.cream,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ComicColors.red,
            foregroundColor: ComicColors.cream,
            minimumSize: const Size.fromHeight(52),
            tapTargetSize: MaterialTapTargetSize.padded,
            textStyle: GoogleFonts.nunito(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999)),
          ),
        ),
      );

  static ThemeData get light => lightFor();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
          secondary: ComicColors.yellow,
          tertiary: ComicColors.green,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      );
}
