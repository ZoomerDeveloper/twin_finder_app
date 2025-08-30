// import 'package:dio/dio.dart';
// import 'package:dio_toolkit/dio_toolkit.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get_it/get_it.dart';

// final GetIt sl = GetIt.instance;

// Future<void> init() async {
//   //Cubit
//   //Auth

//   sl.registerLazySingleton<DioToolkitClient>(() {
//     return DioToolkitClient.withDefaults(
//       baseUrl: 'https://api.example.com',
//       tokenProvider: () async => _accessToken,
//       tokenRefresher: () async {
//         // здесь делаем запрос рефреша
//         // final res = await dio.post('/auth/refresh', data: {'refresh_token': _refreshToken});
//         // return RefreshTokens(accessToken: res.data['access'], refreshToken: res.data['refresh']);
//         // Для примера вернём фиктивные значения:
//         return const RefreshTokens(
//           accessToken: 'NEW_ACCESS',
//           refreshToken: 'NEW_REFRESH',
//         );
//       },
//       onTokensUpdated: (tokens) {
//         _accessToken = tokens.accessToken;
//         _refreshToken = tokens.refreshToken;
//       },
//       isRefreshRequest: (req) => req.path.contains('/auth/refresh'),
//       enableLogging: true,
//     );
//   });

//   sl.registerLazySingleton<Dio>(() {
//     if (kDebugMode) {
//       return Dio(
//           BaseOptions(
//             baseUrl: Endpoints.baseUrl,
//             receiveTimeout: const Duration(seconds: 10),
//             sendTimeout: const Duration(seconds: 10),
//             connectTimeout: const Duration(seconds: 10),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//             validateStatus: (status) {
//               if (status == 502 || status == 500) {
//                 // popupManager.showPopup(
//                 //   'Информация',
//                 //   'Сервер временно не отвечает, попробуйте позже',
//                 //   error: true,
//                 //   () => null,
//                 // );
//               }
//               if (status == 422) {
//                 // popupManager.showPopup(
//                 //   'Информация',
//                 //   'Не удалось обработать запрос. Обратитесь в поддержку',
//                 //   error: true,
//                 //   () => null,
//                 // );
//               }
//               return status! <= 400;
//             },
//           ),
//         )
//         // ..interceptors.add(
//         //   PrettyDioLogger(
//         //     requestHeader: true,
//         //     requestBody: true,
//         //     responseBody: true,
//         //     error: true,
//         //     compact: true,
//         //     maxWidth: 90,
//         //     responseHeader: false,
//         //   ),
//         // )
//         ..interceptors.add(DatasourceInterceptor());
//     }
//     return Dio(
//       BaseOptions(
//         baseUrl: Endpoints.baseUrl,
//         validateStatus: (status) {
//           if (status == 502 || status == 500) {
//             // popupManager.showPopup(
//             //   'Информация',
//             //   'Сервер временно не отвечает, попробуйте позже',
//             //   error: true,
//             //   () => null,
//             // );
//           }
//           if (status == 422) {
//             // popupManager.showPopup(
//             //   'Информация',
//             //   'Не удалось обработать запрос. Обратитесь в поддержку',
//             //   error: true,
//             //   () => null,
//             // );
//           }
//           return status! <= 400;
//         },
//       ),
//     )..interceptors.add(DatasourceInterceptor());
//   });
//   sl.registerLazySingleton<AuthCubit>(() => AuthCubit());
//   // sl.registerLazySingleton<FashionCubit>(() => FashionCubit());
//   // sl.registerLazySingleton<MainCubit>(() => MainCubit());
//   // sl.registerLazySingleton<DeviceIdentifier>(() => DeviceIdentifier());
//   // sl.registerFactory<Logger>(() => Logger());
// }
