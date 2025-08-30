import 'package:flutter/material.dart';
import 'app_localizations.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any((supportedLocale) {
      return supportedLocale.languageCode == locale.languageCode;
    });
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
