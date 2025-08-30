import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:dio/dio.dart';
import 'package:twin_finder/core/errors/api_error.dart';
import 'package:twin_finder/core/utils/app_colors.dart';

class ErrorHandler {
  static void showError(BuildContext context, dynamic error, {String? title}) {
    String message;
    ToastificationType type = ToastificationType.error;
    String customTitle = title ?? 'Error';

    if (error is ApiError) {
      message = error.message;
      type = _getToastType(error);
    } else if (error is String) {
      message = error;
    } else {
      // Специальная обработка для DioException
      message = _extractErrorMessage(error);
    }

    // Специальная обработка для ошибок подключения
    if (_isConnectionError(error)) {
      customTitle = 'Connection Error';
      message = _getConnectionErrorMessage(error);
      type = ToastificationType.warning;
    }

    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      title: Text(
        customTitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Bricolage Grotesque',
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          height: 1.3,
          fontFamily: 'Bricolage Grotesque',
        ),
      ),
      autoCloseDuration: const Duration(seconds: 5),
      // primaryColor: AppColors.backgroundTop,
      // backgroundColor: _getBackgroundColor(type),
      backgroundColor: AppColors.white,
      foregroundColor: Colors.white,
      // icon: _getIcon(type),
      closeButton: const ToastCloseButton(),
      dragToClose: true,
      closeOnClick: true,
      showProgressBar: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
        linearTrackColor: Colors.white24,
      ),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,

      title: Text(
        title ?? 'Success',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Bricolage Grotesque',
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          height: 1.3,
          fontFamily: 'Bricolage Grotesque',
        ),
      ),
      autoCloseDuration: const Duration(seconds: 3),
      backgroundColor: _getBackgroundColor(ToastificationType.success),
      foregroundColor: Colors.white,
      icon: _getIcon(ToastificationType.success),
      closeButton: const ToastCloseButton(),
      dragToClose: true,
      closeOnClick: true,
      showProgressBar: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
        linearTrackColor: Colors.white24,
      ),
    );
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(
        title ?? 'Information',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.3),
      ),
      autoCloseDuration: const Duration(seconds: 4),
      backgroundColor: _getBackgroundColor(ToastificationType.info),
      foregroundColor: Colors.white,
      icon: _getIcon(ToastificationType.info),
      closeButton: const ToastCloseButton(),
      dragToClose: true,
      closeOnClick: true,
      showProgressBar: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
        linearTrackColor: Colors.white24,
      ),
    );
  }

  static ToastificationType _getToastType(ApiError error) {
    if (error.isAuthenticationError) {
      return ToastificationType.error;
    } else if (error.isValidationError) {
      return ToastificationType.warning;
    } else if (error.isServerError) {
      return ToastificationType.error;
    } else if (error.isNetworkError) {
      return ToastificationType.warning;
    }
    return ToastificationType.error;
  }

  static Color _getBackgroundColor(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const Color.fromARGB(255, 255, 255, 255); // Насыщенный зеленый
      case ToastificationType.error:
        return const Color.fromARGB(255, 255, 255, 255); // Насыщенный красный
      case ToastificationType.warning:
        return const Color.fromARGB(255, 255, 255, 255); // Насыщенный оранжевый
      case ToastificationType.info:
        return const Color.fromARGB(255, 255, 255, 255); // Насыщенный синий
      default:
        return const Color.fromARGB(255, 255, 255, 255);
    }
  }

  static Icon _getIcon(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const Icon(
          Icons.check_circle_outline,
          color: Color.fromARGB(255, 0, 201, 7),
          size: 24,
        );
      case ToastificationType.error:
        return const Icon(Icons.error_outline, color: Colors.white, size: 24);
      case ToastificationType.warning:
        return const Icon(
          Icons.warning_amber_outlined,
          color: Colors.white,
          size: 24,
        );
      case ToastificationType.info:
        return const Icon(Icons.info_outline, color: Colors.white, size: 24);
      default:
        return const Icon(Icons.error_outline, color: Colors.white, size: 24);
    }
  }

  static String getErrorMessage(dynamic error) {
    if (error is ApiError) {
      return error.message;
    } else if (error is String) {
      return error;
    } else {
      return error.toString();
    }
  }

  static bool isNetworkError(dynamic error) {
    if (error is ApiError) {
      return error.isNetworkError;
    }
    return _isConnectionError(error);
  }

  static bool isServerError(dynamic error) {
    if (error is ApiError) {
      return error.isServerError;
    }
    return error.toString().toLowerCase().contains('500') ||
        error.toString().toLowerCase().contains('server') ||
        error.toString().toLowerCase().contains('internal');
  }

  static bool _isConnectionError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Проверяем DioException
    if (errorString.contains('dioexception')) {
      if (errorString.contains('connection refused') ||
          errorString.contains('connection error') ||
          errorString.contains('connection timeout') ||
          errorString.contains('network error')) {
        return true;
      }
    }

    // Общие проверки
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('refused') ||
        errorString.contains('unreachable');
  }

  static String _getConnectionErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('dioexception')) {
      if (errorString.contains('connection refused')) {
        return 'Connection refused. Please check your internet connection and try again.';
      } else if (errorString.contains('connection error')) {
        return 'Connection error. Please check your internet connection and try again.';
      } else if (errorString.contains('connection timeout')) {
        return 'Connection timeout. Please check your internet connection and try again.';
      } else if (errorString.contains('network error')) {
        return 'Network error. Please check your internet connection and try again.';
      }
    }
    return 'Unable to connect to server. Please check your internet connection and try again.';
  }

  static String _extractErrorMessage(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      if (response != null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // Приоритет: detail > message > error > default
        if (data.containsKey('detail')) {
          return data['detail'] as String;
        } else if (data.containsKey('message')) {
          return data['message'] as String;
        } else if (data.containsKey('error')) {
          return data['error'] as String;
        }
      }

      // Если нет данных в response, используем statusMessage
      if (response?.statusMessage != null &&
          response!.statusMessage!.isNotEmpty) {
        return response.statusMessage!;
      }
    }

    // Для других типов ошибок
    return error.toString();
  }
}
