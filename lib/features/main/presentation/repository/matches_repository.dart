import 'package:dio/dio.dart';
import 'package:twin_finder/api/models/matches_response.dart';

class MatchesRepository {
  final Dio _dio;

  MatchesRepository(this._dio);

  Future<MatchesResponse> getMatches({int page = 0, int perPage = 20}) async {
    try {
      final response = await _dio.get(
        '/v1/matches/',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      return MatchesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to load matches: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('Unauthorized. Please login again.');
        } else if (statusCode == 403) {
          return Exception('Access denied.');
        } else if (statusCode == 404) {
          return Exception('Matches not found.');
        } else if (statusCode == 500) {
          return Exception('Server error. Please try again later.');
        } else {
          return Exception('Failed to load matches. Status: $statusCode');
        }
      case DioExceptionType.cancel:
        return Exception('Request cancelled.');
      case DioExceptionType.connectionError:
        return Exception(
          'Connection error. Please check your internet connection.',
        );
      default:
        return Exception('Network error. Please try again.');
    }
  }
}
