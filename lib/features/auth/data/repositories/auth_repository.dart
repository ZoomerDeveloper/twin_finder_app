import 'package:dio_toolkit/dio_toolkit.dart';

class AuthRepository {
  final client = DioToolkitClient.withDefaults(
    baseUrl: 'https://api.example.com',
    // tokenProvider: () async => _accessToken,
    // tokenRefresher: () async {
    //   // здесь делаем запрос рефреша
    //   // final res = await dio.post('/auth/refresh', data: {'refresh_token': _refreshToken});
    //   // return RefreshTokens(accessToken: res.data['access'], refreshToken: res.data['refresh']);
    //   // Для примера вернём фиктивные значения:
    //   return const RefreshTokens(
    //     accessToken: 'NEW_ACCESS',
    //     refreshToken: 'NEW_REFRESH',
    //   );
    // },
    // onTokensUpdated: (tokens) {
    //   _accessToken = tokens.accessToken;
    //   _refreshToken = tokens.refreshToken;
    // },
    isRefreshRequest: (req) => req.path.contains('/auth/refresh'),
    enableLogging: true,
  );

  Future<void> loginGoogle(String idToken) async {
    try {
      final res = await client.post<String>(
        '/auth/google',
        body: {'id_token': idToken},
        decoder: (data) {
          return data.toString();
        },
      );

      res.when(
        success: (String data) {
          return data; // Здесь можно обработать успешный ответ
        },
        failure: (error) {
          throw Exception('Login failed: $error');
        },
      );
    } catch (e) {
      // Handle error
    }
  }
}
