import 'package:dio/dio.dart';
import 'package:twin_finder/api/api_client.dart';
import 'package:twin_finder/api/models/match_list_response.dart';
import 'package:twin_finder/core/utils/token_secure.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

class MatchesRepository {
  final ApiClient _apiClient;

  MatchesRepository(Dio dio) : _apiClient = ApiClient(dio);

  Future<MatchListResponse> getMatches({int page = 0, int perPage = 20}) async {
    try {
      // Check if user is authenticated
      final tokenStore = GetIt.instance<TokenStore>();
      final accessToken = await tokenStore.access;

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token available for matches request');
        throw Exception('Authentication required - please login first');
      }

      debugPrint(
        'Loading matches with token: ${accessToken.substring(0, 20)}...',
      );

      // API expects 1-based page numbers, but we use 0-based internally
      final apiPage = page + 1;
      debugPrint('Making API request: page=$apiPage, perPage=$perPage');

      final response = await _apiClient.matches.getMatchesApiV1MatchesGet(
        page: apiPage,
        perPage: perPage,
        minSimilarity: null,
        maxSimilarity: null,
        viewedOnly: null,
      );

      debugPrint('API response received: ${response.matches.length} matches');
      return response;
    } on DioException catch (e) {
      debugPrint('DioException in getMatches: ${e.type} - ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('General error in getMatches: $e');
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
