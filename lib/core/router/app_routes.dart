abstract class AppRoutes {
  static const String splash = '/splash'; // Splash screen
  static const String home = '/';
  static const String auth = '/auth';
  static const String emailLogin = '/emailLogin';
  static const String emailSignup = '/emailSignup';
  static const String name = '/name';
  static const String birthday = '/birthday';
  static const String gender = '/gender';
  static const String location = '/location';
  static const String info = '/info';
  static const String faceCapturePage = '/faceCapture';
  static const String emailVerification = '/emailVerification';
  static const String emailCode = '/emailCode';
  static const String main = '/main'; // Главная страница с BottomNavigationBar
  static const String changeProfileDetails = '/change-profile-details';

  static const String deleteAccount = '/deleteAccount';

  // Дополнительно: можно добавить метод для проверки существования маршрута
  static bool isRouteValid(String route) {
    return [
      home,
      auth,
      emailLogin,
      emailSignup,
      name,
      birthday,
      gender,
      location,
      info,
      faceCapturePage,
      emailVerification,
      emailCode,
    ].contains(route);
  }
}
