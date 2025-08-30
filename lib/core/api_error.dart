class ApiError implements Exception {
  final int? statusCode;
  final String message;
  final Object? details;

  ApiError({this.statusCode, required this.message, this.details});

  @override
  String toString() => 'ApiError($statusCode): $message';
}
