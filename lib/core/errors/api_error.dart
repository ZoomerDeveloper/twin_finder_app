import 'package:dio/dio.dart';

class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final String? type;
  final String? detail;

  ApiError({required this.message, this.statusCode, this.type, this.detail});

  factory ApiError.fromDioException(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      final statusCode = response?.statusCode;
      final data = response?.data;

      if (data is Map<String, dynamic>) {
        return ApiError(
          message: _extractMessage(data, statusCode),
          statusCode: statusCode,
          type: data['type'] as String?,
          detail: data['detail'] as String?,
        );
      } else {
        return ApiError(
          message: _extractMessage(null, statusCode),
          statusCode: statusCode,
        );
      }
    }

    return ApiError(message: error.toString());
  }

  static String _extractMessage(Map<String, dynamic>? data, int? statusCode) {
    if (data != null) {
      // Try to extract user-friendly message from API response
      if (data['detail'] != null) {
        return data['detail'] as String;
      }
      if (data['message'] != null) {
        return data['message'] as String;
      }
    }

    // Fallback to status code based messages
    switch (statusCode) {
      case 400:
        return 'Bad request - please check your input';
      case 401:
        return 'Incorrect email or password';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Conflict - resource already exists';
      case 422:
        return 'Validation error - please check your input';
      case 429:
        return 'Too many requests - please try again later';
      case 500:
        return 'Server error - please try again later';
      case 502:
        return 'Bad gateway - please try again later';
      case 503:
        return 'Service unavailable - please try again later';
      default:
        return 'An error occurred - please try again';
    }
  }

  @override
  String toString() {
    if (detail != null && detail!.isNotEmpty) {
      return detail!;
    }
    return message;
  }

  bool get isAuthenticationError => statusCode == 401;
  bool get isValidationError => statusCode == 400 || statusCode == 422;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNetworkError => statusCode == null;
}
