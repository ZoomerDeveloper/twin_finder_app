// lib/core/network/dio_setup.dart
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:twin_finder/api/models/refresh_token_request.dart';
import 'package:twin_finder/core/utils/token_secure.dart';
import '../../api/api_client.dart'; // экспорт swagger_parser

final sl = GetIt.instance;

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.twinfinder.app', // продакшн API
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

  bool _isExpiringSoon(String jwt, {int thresholdSeconds = 120}) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return false;
      String normalized = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }
      final payloadMap = _tryParseJson(String.fromCharCodes(
        Base64Decoder().convert(normalized),
      ));
      if (payloadMap == null) return false;
      final exp = payloadMap['exp'];
      if (exp is int) {
        final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        final now = DateTime.now();
        return expiresAt.difference(now).inSeconds <= thresholdSeconds;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic>? _tryParseJson(String s) {
    try {
      return s.isEmpty ? null : (jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokenStore = sl<TokenStore>();
    String? token = await tokenStore.access;

    // Proactive refresh if token is about to expire soon
    if (token != null && token.isNotEmpty && _isExpiringSoon(token)) {
      final api = sl<ApiClient>();
      final refresh = await tokenStore.refresh;
      if (refresh != null && refresh.isNotEmpty && !_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshed = await api.authentication
              .refreshTokens(body: RefreshTokenRequest(refreshToken: refresh));
          await tokenStore.save(
            access: refreshed.data?.accessToken,
            refresh: refreshed.data?.refreshToken,
          );
          token = refreshed.data?.accessToken ?? token;
        } catch (_) {
          // fall back to old token; 401 flow will handle if needed
        } finally {
          _isRefreshing = false;
        }
      }
    }

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
