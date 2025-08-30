// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:twin_finder/api/rest_client.dart';
// import 'package:twin_finder/core/api_client.dart';

// class AuthInterceptor extends Interceptor {
//   final GetIt sl;
//   AuthInterceptor(this.sl);

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final token = sl<TokenStore>().accessToken; // сам реализуешь
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401 && !_isRefresh(err.requestOptions)) {
//       final ok = await _refreshToken();
//       if (ok) {
//         final clone = await _retry(err.requestOptions);
//         return handler.resolve(clone);
//       }
//     }
//     handler.next(err);
//   }

//   bool _isRefresh(RequestOptions o) => o.path.contains('/auth/refresh');

//   Future<bool> _refreshToken() async {
//     try {
//       final api = sl<RestClient>();
//       final resp = await api. .refreshToken();
//       sl<TokenStorage>().saveTokens(resp.accessToken, resp.refreshToken);
//       return true;
//     } catch (_) {
//       sl<TokenStore>().clear();
//       return false;
//     }
//   }

//   Future<Response<dynamic>> _retry(RequestOptions o) {
//     final dio = sl<Dio>();
//     return dio.fetch<dynamic>(
//       o.copyWith(
//         headers: Map<String, dynamic>.from(o.headers),
//         data: o.data,
//         queryParameters: o.queryParameters,
//       ),
//     );
//   }
// }

// class RetryInterceptor extends Interceptor {
//   final Dio dio;
//   RetryInterceptor(this.dio);

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (_isTransient(err)) {
//       try {
//         await Future.delayed(const Duration(milliseconds: 300));
//         final res = await dio.fetch(err.requestOptions);
//         return handler.resolve(res);
//       } catch (_) { /* fallthrough */ }
//     }
//     handler.next(err);
//   }

//   bool _isTransient(DioException e) =>
//       e.type == DioExceptionType.connectionTimeout ||
//       e.type == DioExceptionType.receiveTimeout ||
//       e.type == DioExceptionType.connectionError;
// }
