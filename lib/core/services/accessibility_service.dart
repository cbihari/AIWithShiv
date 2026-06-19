import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings {
  const AccessibilitySettings({
    required this.easyReading,
    required this.dataSaver,
  });

  final bool easyReading;
  final bool dataSaver;

  AccessibilitySettings copyWith({bool? easyReading, bool? dataSaver}) {
    return AccessibilitySettings(
      easyReading: easyReading ?? this.easyReading,
      dataSaver: dataSaver ?? this.dataSaver,
    );
  }
}

class AccessibilityService {
  AccessibilityService._();

  static final instance = AccessibilityService._();
  static final settings = ValueNotifier<AccessibilitySettings>(
    const AccessibilitySettings(easyReading: false, dataSaver: false),
  );

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    settings.value = AccessibilitySettings(
      easyReading: prefs.getBool('easy_reading_mode') ?? false,
      dataSaver: prefs.getBool('data_saver_mode') ?? false,
    );
  }

  Future<void> setEasyReading(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('easy_reading_mode', value);
    settings.value = settings.value.copyWith(easyReading: value);
  }

  Future<void> setDataSaver(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('data_saver_mode', value);
    settings.value = settings.value.copyWith(dataSaver: value);
  }
}
