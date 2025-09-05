import 'package:dio/dio.dart';
import 'package:twin_finder/api/api_client.dart';
import 'package:twin_finder/api/models/match_list_response.dart';

class MatchesRepository {
  final ApiClient _apiClient;

  MatchesRepository(Dio dio) : _apiClient = ApiClient(dio);

  Future<MatchListResponse> getMatches({int page = 0, int perPage = 20}) async {
    try {
      return await _apiClient.matches.getMatchesApiV1MatchesGet(
        page: page,
        perPage: perPage,
      );
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
