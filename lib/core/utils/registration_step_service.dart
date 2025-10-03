import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service to persist and retrieve the current registration step
/// This allows users to resume registration from where they left off
class RegistrationStepService {
  static const _storage = FlutterSecureStorage();
  static const _stepKey = 'registration_step';

  // Registration steps in order
  static const String stepName = 'name';
  static const String stepBirthday = 'birthday';
  static const String stepGender = 'gender';
  static const String stepLocation = 'location';
  static const String stepPhoto = 'photo';
  static const String stepComplete = 'complete';

  /// Get the saved registration step
  static Future<String?> getCurrentStep() async {
    try {
      final step = await _storage.read(key: _stepKey);
      return step;
    } catch (e) {
      return null;
    }
  }

  /// Save the current registration step
  static Future<void> saveStep(String step) async {
    try {
      await _storage.write(key: _stepKey, value: step);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Clear the saved registration step (when registration is complete)
  static Future<void> clearStep() async {
    try {
      await _storage.delete(key: _stepKey);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Determine which step should be next based on profile data
  static String determineIncompleteStep({
    required String? name,
    required DateTime? birthday,
    required String? gender,
    required String? country,
    required String? city,
    required String? profilePhotoUrl,
  }) {
    if (name == null || name.isEmpty) return stepName;
    if (birthday == null) return stepBirthday;
    if (gender == null) return stepGender;
    if (country == null || city == null) return stepLocation;
    if (profilePhotoUrl == null) return stepPhoto;
    return stepComplete;
  }
}
