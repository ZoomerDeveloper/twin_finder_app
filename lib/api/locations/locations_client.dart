// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'locations_client.g.dart';

@RestApi()
abstract class LocationsClient {
  factory LocationsClient(Dio dio, {String? baseUrl}) = _LocationsClient;

  /// Get Location Suggestions.
  ///
  /// Get location suggestions for autocomplete using Open-Meteo geocoding API.
  ///            
  ///             This endpoint provides location suggestions based on a search query,.
  ///             useful for implementing autocomplete functionality in the frontend.
  ///            
  ///             **Rate Limiting**: 100 requests per minute.
  ///
  /// [query] - Search query for location.
  ///
  /// [limit] - Maximum number of suggestions to return.
  @GET('/api/v1/locations/suggestions')
  Future<dynamic> getLocationSuggestionsApiV1LocationsSuggestionsGet({
    @Query('query') required String query,
    @Query('limit') int? limit = 5,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Validate Location.
  ///
  /// Validate a country and city combination using Open-Meteo geocoding API.
  ///             
  ///              This endpoint validates that a country and city combination exists and.
  ///              matches together. Useful for verifying user input before saving to database.
  ///             
  ///              **Rate Limiting**: 50 requests per minute.
  ///
  /// [country] - Country name.
  ///
  /// [city] - City name.
  @POST('/api/v1/locations/validate')
  Future<dynamic> validateLocationApiV1LocationsValidatePost({
    @Query('country') required String country,
    @Query('city') required String city,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Validate Country.
  ///
  /// Validate that a country exists using Open-Meteo geocoding API.
  ///            
  ///             This endpoint validates that a country name exists and is valid.
  ///            
  ///             **Rate Limiting**: 100 requests per minute.
  ///
  /// [country] - Country name.
  @GET('/api/v1/locations/validate/country')
  Future<dynamic> validateCountryApiV1LocationsValidateCountryGet({
    @Query('country') required String country,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Validate City.
  ///
  /// Validate that a city exists using Open-Meteo geocoding API.
  ///            
  ///             This endpoint validates that a city name exists and is valid.
  ///            
  ///             **Rate Limiting**: 100 requests per minute.
  ///
  /// [city] - City name.
  @GET('/api/v1/locations/validate/city')
  Future<dynamic> validateCityApiV1LocationsValidateCityGet({
    @Query('city') required String city,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
