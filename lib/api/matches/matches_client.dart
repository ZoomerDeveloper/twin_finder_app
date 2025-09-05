// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/match_discovery_response.dart';
import '../models/match_generation_request.dart';
import '../models/match_generation_response.dart';
import '../models/match_list_response.dart';
import '../models/match_stats.dart';
import '../models/match_update.dart';
import '../models/match_with_user.dart';

part 'matches_client.g.dart';

@RestApi()
abstract class MatchesClient {
  factory MatchesClient(Dio dio, {String? baseUrl}) = _MatchesClient;

  /// Generate mock matches.
  ///
  /// Generate mock matches for the current user using random selection and similarity scoring.
  @POST('/api/v1/matches/generate')
  Future<MatchGenerationResponse> generateMatchesApiV1MatchesGeneratePost({
    @Body() required MatchGenerationRequest body,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Generate random matches.
  ///
  /// Generate random matches for the current user using a simple random algorithm. This is a placeholder for the neural network matching system.
  ///
  /// [count] - Number of matches to generate.
  ///
  /// [minSimilarity] - Minimum similarity score for generated matches.
  ///
  /// [maxSimilarity] - Maximum similarity score for generated matches.
  @POST('/api/v1/matches/generate/random')
  Future<MatchGenerationResponse> generateRandomMatchesApiV1MatchesGenerateRandomPost({
    @Query('min_similarity') dynamic minSimilarity,
    @Query('max_similarity') dynamic maxSimilarity,
    @Query('token') String? token,
    @Query('count') int? count = 10,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get user matches.
  ///
  /// Get paginated list of matches for the current user with optional filtering.
  ///
  /// [page] - Page number (1-based).
  ///
  /// [perPage] - Number of matches per page.
  ///
  /// [viewedOnly] - Filter by viewed status.
  ///
  /// [minSimilarity] - Minimum similarity score filter.
  ///
  /// [maxSimilarity] - Maximum similarity score filter.
  @GET('/api/v1/matches/')
  Future<MatchListResponse> getMatchesApiV1MatchesGet({
    @Query('viewed_only') bool? viewedOnly,
    @Query('min_similarity') dynamic minSimilarity,
    @Query('max_similarity') dynamic maxSimilarity,
    @Query('token') String? token,
    @Query('page') int? page = 1,
    @Query('per_page') int? perPage = 20,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Discover matches for endless scroll.
  ///
  /// Get matches for discovery with endless scroll functionality. Returns up to 8 matches ordered from least to most relevant, filtered by minimum 60% similarity score.
  ///
  /// [offset] - Number of matches to skip for pagination.
  ///
  /// [limit] - Number of matches to return (max 8).
  @GET('/api/v1/matches/discover')
  Future<MatchDiscoveryResponse> discoverMatchesApiV1MatchesDiscoverGet({
    @Query('token') String? token,
    @Query('offset') int? offset = 0,
    @Query('limit') int? limit = 8,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get specific match.
  ///
  /// Get a specific match by ID for the current user.
  @GET('/api/v1/matches/{match_id}')
  Future<MatchWithUser> getMatchApiV1MatchesMatchIdGet({
    @Path('match_id') required String matchId,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Update match.
  ///
  /// Update a match with new data (similarity score, viewed status).
  @PATCH('/api/v1/matches/{match_id}')
  Future<MatchWithUser> updateMatchApiV1MatchesMatchIdPatch({
    @Path('match_id') required String matchId,
    @Body() required MatchUpdate body,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Delete match.
  ///
  /// Delete a specific match for the current user.
  @DELETE('/api/v1/matches/{match_id}')
  Future<void> deleteMatchApiV1MatchesMatchIdDelete({
    @Path('match_id') required String matchId,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Mark match as viewed.
  ///
  /// Mark a specific match as viewed by the current user.
  @POST('/api/v1/matches/{match_id}/view')
  Future<MatchWithUser> markMatchAsViewedApiV1MatchesMatchIdViewPost({
    @Path('match_id') required String matchId,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get match statistics.
  ///
  /// Get comprehensive statistics about the current user's matches.
  @GET('/api/v1/matches/stats/summary')
  Future<MatchStats> getMatchStatsApiV1MatchesStatsSummaryGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get unviewed match count.
  ///
  /// Get the count of unviewed matches for the current user.
  @GET('/api/v1/matches/stats/unviewed-count')
  Future<void> getUnviewedCountApiV1MatchesStatsUnviewedCountGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
