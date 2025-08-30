import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageService {
  static const _storage = FlutterSecureStorage();
  static const _languageKey = 'selected_language';

  // Get saved language
  static Future<String> getSavedLanguage() async {
    try {
      final language = await _storage.read(key: _languageKey);
      return language ?? 'en';
    } catch (e) {
      return 'en';
    }
  }

  // Save selected language
  static Future<void> saveLanguage(String languageCode) async {
    try {
      await _storage.write(key: _languageKey, value: languageCode);
    } catch (e) {
      // Handle error silently
    }
  }

  // Get system language
  static String getSystemLanguage() {
    // For now, return default language
    // In a real app, you would get this from the system
    return 'en';
  }

  // Get supported languages
  static List<String> getSupportedLanguages() {
    return ['en', 'es', 'zh', 'ru'];
  }

  // Check if language is supported
  static bool isLanguageSupported(String languageCode) {
    return getSupportedLanguages().contains(languageCode);
  }
}
