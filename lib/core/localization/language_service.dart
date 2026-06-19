import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('en', 'English'),
  hindi('hi', 'हिन्दी');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return switch (code) {
      'hi' => AppLanguage.hindi,
      _ => AppLanguage.english,
    };
  }
}

class LanguageService {
  LanguageService._();

  static final instance = LanguageService._();
  static final language = ValueNotifier<AppLanguage>(AppLanguage.english);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    language.value = AppLanguage.fromCode(prefs.getString('app_language'));
  }

  Future<void> setLanguage(AppLanguage value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', value.code);
    language.value = value;
  }
}
