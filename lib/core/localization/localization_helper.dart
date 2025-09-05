import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// Helper class for quick localization across the app
class L {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  /// Quick access to localized strings
  static String s(BuildContext context, String key) {
    return AppLocalizations.of(context).getString(key);
  }

  /// Quick access to localized strings with parameters
  static String sp(
    BuildContext context,
    String key,
    Map<String, String> params,
  ) {
    return AppLocalizations.of(context).getStringWithParams(key, params);
  }

  /// Common localized strings
  static String cancel(BuildContext context) => s(context, 'cancel');
  static String done(BuildContext context) => s(context, 'done');
  static String continue_(BuildContext context) => s(context, 'continue');
  static String next(BuildContext context) => s(context, 'next');
  static String yes(BuildContext context) => s(context, 'yes');
  static String no(BuildContext context) => s(context, 'no');
  static String error(BuildContext context) => s(context, 'error');
  static String success(BuildContext context) => s(context, 'success');
  static String loading(BuildContext context) => s(context, 'loading');

  /// Auth page localized strings
  static String findYourTwin(BuildContext context) =>
      s(context, 'find_your_twin');
  static String continueWithGoogle(BuildContext context) =>
      s(context, 'continue_with_google');
  static String connectWithApple(BuildContext context) =>
      s(context, 'connect_with_apple');
  static String signUpWithEmail(BuildContext context) =>
      s(context, 'sign_up_with_email');
  static String signInWithEmail(BuildContext context) =>
      s(context, 'sign_in_with_email');
  static String termsOfService(BuildContext context) =>
      s(context, 'terms_of_service');
  static String privacyPolicy(BuildContext context) =>
      s(context, 'privacy_policy');
  static String cookiePolicy(BuildContext context) =>
      s(context, 'cookie_policy');
  static String bySigningUp(BuildContext context) =>
      s(context, 'by_signing_up');
  static String andAcknowledge(BuildContext context) =>
      s(context, 'and_acknowledge');
  static String and(BuildContext context) => s(context, 'and');

  /// Profile setup localized strings
  static String whatIsYourName(BuildContext context) =>
      s(context, 'what_is_your_name');
  static String thisWillAppearOnProfile(BuildContext context) =>
      s(context, 'this_will_appear_on_your_profile');
  static String name(BuildContext context) => s(context, 'name');
  static String nameRequired(BuildContext context) =>
      s(context, 'name_required');
  static String yourAge(BuildContext context) => s(context, 'your_age');
  static String yourGender(BuildContext context) => s(context, 'your_gender');
  static String age(BuildContext context) => s(context, 'age');
  static String location(BuildContext context) => s(context, 'location');
  static String whenWereYouBorn(BuildContext context) =>
      s(context, 'when_were_you_born');
  static String whatIsYourGender(BuildContext context) =>
      s(context, 'what_is_your_gender');
  static String whereAreYouFrom(BuildContext context) =>
      s(context, 'where_are_you_from');
  static String yourName(BuildContext context) => s(context, 'your_name');
  static String enterYourName(BuildContext context) =>
      s(context, 'enter_your_name');
  static String birthday(BuildContext context) => s(context, 'birthday');
  static String selectYourBirthday(BuildContext context) =>
      s(context, 'select_your_birthday');
  static String gender(BuildContext context) => s(context, 'gender');
  static String male(BuildContext context) => s(context, 'male');
  static String female(BuildContext context) => s(context, 'female');
  static String country(BuildContext context) => s(context, 'country');
  static String selectCountry(BuildContext context) =>
      s(context, 'select_country');
  static String city(BuildContext context) => s(context, 'select_city');
  static String selectCity(BuildContext context) => s(context, 'select_city');
  static String selectCountryFirst(BuildContext context) =>
      s(context, 'select_country_first');
  static String searchCountry(BuildContext context) =>
      s(context, 'search_country');
  static String searchCity(BuildContext context) => s(context, 'search_city');
  static String noCountriesFound(BuildContext context) =>
      s(context, 'no_countries_found');
  static String noCitiesFound(BuildContext context) =>
      s(context, 'no_cities_found');
  static String popularCities(BuildContext context) =>
      s(context, 'popular_cities');
  static String ageRequirement(BuildContext context) =>
      s(context, 'age_requirement');
  static String invalidBirthDate(BuildContext context) =>
      s(context, 'invalid_birth_date');
  static String pleaseSelectGender(BuildContext context) =>
      s(context, 'please_select_gender');
  static String pleaseSelectCountry(BuildContext context) =>
      s(context, 'please_select_country');
  static String pleaseSelectCity(BuildContext context) =>
      s(context, 'please_select_city');

  /// Email pages localized strings
  static String email(BuildContext context) => s(context, 'email');
  static String password(BuildContext context) => s(context, 'password');
  static String confirmPassword(BuildContext context) =>
      s(context, 'confirm_password');
  static String enterEmail(BuildContext context) => s(context, 'enter_email');
  static String enterPassword(BuildContext context) =>
      s(context, 'enter_password');
  static String confirmYourPassword(BuildContext context) =>
      s(context, 'confirm_your_password');
  static String signUp(BuildContext context) => s(context, 'sign_up');
  static String signIn(BuildContext context) => s(context, 'sign_in');
  static String alreadyHaveAccount(BuildContext context) =>
      s(context, 'already_have_account');
  static String dontHaveAccount(BuildContext context) =>
      s(context, 'dont_have_account');
  static String verificationCode(BuildContext context) =>
      s(context, 'verification_code');
  static String enterVerificationCode(BuildContext context) =>
      s(context, 'enter_verification_code');
  static String codeSent(BuildContext context) => s(context, 'code_sent');
  static String enterEmailAndPassword(BuildContext context) =>
      s(context, 'enter_email_and_password');
  static String resendCode(BuildContext context) => s(context, 'resend_code');
  static String verify(BuildContext context) => s(context, 'verify');
  static String invalidCode(BuildContext context) => s(context, 'invalid_code');
  static String passwordMismatch(BuildContext context) =>
      s(context, 'password_mismatch');
  static String emailAlreadyExists(BuildContext context) =>
      s(context, 'email_already_exists');
  static String invalidEmail(BuildContext context) =>
      s(context, 'invalid_email');
  static String weakPassword(BuildContext context) =>
      s(context, 'weak_password');

  /// Main app localized strings
  static String welcome(BuildContext context) => s(context, 'welcome');
  static String settings(BuildContext context) => s(context, 'settings');
  static String editProfile(BuildContext context) => s(context, 'edit_profile');
  static String changePhoto(BuildContext context) => s(context, 'change_photo');
  static String deleteAccount(BuildContext context) =>
      s(context, 'delete_account');
  static String about(BuildContext context) => s(context, 'about');
  static String version(BuildContext context) => s(context, 'version');
  static String support(BuildContext context) => s(context, 'support');
  static String feedback(BuildContext context) => s(context, 'feedback');
  static String rateApp(BuildContext context) => s(context, 'rate_app');
  static String shareApp(BuildContext context) => s(context, 'share_app');
  static String profile(BuildContext context) => s(context, 'profile');
  static String twinFinder(BuildContext context) => s(context, 'twin_finder');
  static String chat(BuildContext context) => s(context, 'chat');
  static String logout(BuildContext context) => s(context, 'logout');
  static String logoutConfirmation(BuildContext context) =>
      s(context, 'logout_confirmation');
  static String updateProfile(BuildContext context) =>
      s(context, 'update_profile');
  static String profileUpdated(BuildContext context) =>
      s(context, 'profile_updated');

  /// Face capture localized strings
  static String takePhoto(BuildContext context) => s(context, 'take_photo');
  static String retakePhoto(BuildContext context) => s(context, 'retake_photo');
  static String photoCaptured(BuildContext context) =>
      s(context, 'photo_captured');
  static String cameraPermissionRequired(BuildContext context) =>
      s(context, 'camera_permission_required');
  static String pleaseGrantCameraPermission(BuildContext context) =>
      s(context, 'please_grant_camera_permission');
  static String cameraError(BuildContext context) => s(context, 'camera_error');
  static String photoProcessing(BuildContext context) =>
      s(context, 'photo_processing');
  static String lookingForMatches(BuildContext context) =>
      s(context, 'looking_for_matches');

  /// Twin finder localized strings
  static String findMatches(BuildContext context) => s(context, 'find_matches');
  static String noMatchesFound(BuildContext context) =>
      s(context, 'no_matches_found');
  static String swipeRight(BuildContext context) => s(context, 'swipe_right');
  static String swipeLeft(BuildContext context) => s(context, 'swipe_left');
  static String matchFound(BuildContext context) => s(context, 'match_found');
  static String startConversation(BuildContext context) =>
      s(context, 'start_conversation');
  static String matchesDescription(BuildContext context) =>
      s(context, 'matches_description');

  /// Chat localized strings
  static String messages(BuildContext context) => s(context, 'messages');
  static String newMessage(BuildContext context) => s(context, 'new_message');
  static String typeMessage(BuildContext context) => s(context, 'type_message');
  static String send(BuildContext context) => s(context, 'send');
  static String online(BuildContext context) => s(context, 'online');
  static String lastSeen(BuildContext context) => s(context, 'last_seen');
  static String noMessages(BuildContext context) => s(context, 'no_messages');
  static String startChatting(BuildContext context) =>
      s(context, 'start_chatting');
  static String comingSoon(BuildContext context) => s(context, 'coming_soon');
  static String chatsNotAvailable(BuildContext context) =>
      s(context, 'chats_not_available');

  // Change Profile Details
  static String profileSettings(BuildContext context) =>
      s(context, 'profile_settings');
  static String yourCountry(BuildContext context) => s(context, 'your_country');
  static String yourCity(BuildContext context) => s(context, 'your_city');
  static String saveProfile(BuildContext context) => s(context, 'save_profile');

  // Maintenance page
  static String maintenanceTitle(BuildContext context) =>
      s(context, 'maintenance_title');
  static String maintenanceDescription(BuildContext context) =>
      s(context, 'maintenance_description');
  static String maintenanceRetry(BuildContext context) =>
      s(context, 'maintenance_retry');
}
