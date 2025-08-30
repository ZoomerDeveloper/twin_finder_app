import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'localization_delegate.dart';
import 'localization_strings.dart';

class AppLocalizations {
  final Locale locale;
  final LocalizationStrings strings;

  AppLocalizations(this.locale)
    : strings = LocalizationStrings(locale.languageCode);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('es'), // Spanish
    Locale('zh'), // Chinese
    Locale('ru'), // Russian
  ];

  static const Locale fallbackLocale = Locale('en');

  // Language names in their native language
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'zh': '中文',
    'ru': 'Русский',
  };

  // Language names in English
  static const Map<String, String> languageNamesEnglish = {
    'en': 'English',
    'es': 'Spanish',
    'zh': 'Chinese',
    'ru': 'Russian',
  };

  // Get current language code
  String get currentLanguageCode => locale.languageCode;

  // Get current language name
  String get currentLanguageName =>
      languageNames[currentLanguageCode] ?? 'English';

  // Get current language name in English
  String get currentLanguageNameEnglish =>
      languageNamesEnglish[currentLanguageCode] ?? 'English';

  // Check if current language is RTL
  bool get isRTL => locale.languageCode == 'ar' || locale.languageCode == 'he';

  // Format date based on locale
  String formatDate(DateTime date) {
    return DateFormat.yMMMd(locale.languageCode).format(date);
  }

  // Format time based on locale
  String formatTime(TimeOfDay time) {
    return DateFormat.Hm(
      locale.languageCode,
    ).format(DateTime(2024, 1, 1, time.hour, time.minute));
  }

  // Format number based on locale
  String formatNumber(int number) {
    return NumberFormat.decimalPattern(locale.languageCode).format(number);
  }

  // Get localized string by key
  String getString(String key) {
    return strings.getString(key);
  }

  // Get localized string with parameters
  String getStringWithParams(String key, Map<String, String> params) {
    String text = strings.getString(key);
    params.forEach((key, value) {
      text = text.replaceAll('{$key}', value);
    });
    return text;
  }
}
