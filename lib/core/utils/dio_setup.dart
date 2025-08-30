// lib/core/network/dio_setup.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:twin_finder/api/models/refresh_token_request.dart';
import 'package:twin_finder/core/utils/token_secure.dart';
import '../../api/api_client.dart'; // экспорт swagger_parser

final sl = GetIt.instance;

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://161.97.64.169:8000', // из servers в OpenAPI
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.addAll([
    _AuthInterceptor(sl),
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
}

class _AuthInterceptor extends Interceptor {
  final GetIt sl;
  _AuthInterceptor(this.sl);

  bool _isRefreshing = false;
  final List<Function()> _retryQueue = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await sl<TokenStore>().access;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // если 401 — пробуем рефреш
    if (err.response?.statusCode == 401 &&
        !_looksLikeRefresh(err.requestOptions)) {
      final dio = sl<Dio>();
      final tokenStore = sl<TokenStore>();
      final api = sl<ApiClient>();

      // поставим запрос в очередь
      final completer = Completer<Response<dynamic>>();
      _retryQueue.add(() async {
        try {
          final newRes = await dio.fetch<dynamic>(err.requestOptions);
          completer.complete(newRes);
        } catch (e) {
          completer.completeError(e);
        }
      });

      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshToken = await tokenStore.refresh;
          if (refreshToken == null || refreshToken.isEmpty) {
            throw Exception('No refresh token');
          }

          final refreshed = await api.authentication.refreshTokens(
            body: RefreshTokenRequest(refreshToken: refreshToken),
          ); // /api/v1/auth/refresh → AuthResponse  [oai_citation:6‡openapi.json](file-service://file-2spEVPUL8cyHPHHz4NizeK)

          await tokenStore.save(
            access: refreshed.data?.accessToken,
            refresh: refreshed.data?.refreshToken,
          );

          // повторим отложенные запросы
          for (final retry in _retryQueue) {
            await retry();
          }
          _retryQueue.clear();
        } catch (_) {
          await tokenStore.clear();
          // провалим все ожидатели
          for (final retry in _retryQueue) {
            retry();
          }
          _retryQueue.clear();
          return handler.reject(err);
        } finally {
          _isRefreshing = false;
        }
      }

      // дождёмся ретрая текущего запроса
      try {
        final response = await completer.future;
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }
    handler.next(err);
  }

  bool _looksLikeRefresh(RequestOptions o) =>
      o.path.contains('/api/v1/auth/refresh');
}
