// lib/core/di.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:twin_finder/api/api_client.dart';
import 'package:twin_finder/core/utils/dio_setup.dart';
import 'package:twin_finder/core/utils/token_secure.dart';

final sl = GetIt.instance;

Future<void> setupDI() async {
  sl.registerLazySingleton<TokenStore>(() => TokenStore());
  sl.registerLazySingleton<Dio>(() => createDio());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
}
