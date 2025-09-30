// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'fallback_client.g.dart';

@RestApi()
abstract class FallbackClient {
  factory FallbackClient(Dio dio, {String? baseUrl}) = _FallbackClient;

  /// API Information.
  ///
  /// Root endpoint providing basic API information and links to documentation.
  ///             
  ///              This endpoint is useful for:.
  ///              - Checking if the API is running.
  ///              - Getting API version information.
  ///              - Finding links to documentation.
  ///              - Health monitoring and uptime checks.
  @GET('/')
  Future<void> rootGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Redirect Legacy Uploads
  @GET('/app/uploads/{path}')
  Future<void> redirectLegacyUploadsAppUploadsPathGet({
    @Path('path') required String path,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Health Check.
  ///
  /// Health check endpoint for monitoring API status and performance.
  ///             
  ///              This endpoint is designed for:.
  ///              - Load balancer health checks.
  ///              - Monitoring system integration.
  ///              - DevOps deployment verification.
  ///              - API status monitoring.
  @GET('/health')
  Future<void> healthCheckHealthGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Detailed Health Check.
  ///
  /// Detailed health check endpoint for comprehensive system monitoring.
  ///             
  ///              This endpoint provides detailed health information for:.
  ///              - Database connectivity and metrics.
  ///              - Redis connectivity and metrics.
  ///              - Application status and configuration.
  ///              - Component-level health status.
  @GET('/health/detailed')
  Future<void> detailedHealthCheckHealthDetailedGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Prometheus Metrics.
  ///
  /// Prometheus metrics endpoint for monitoring and alerting.
  ///             
  ///              This endpoint exposes application metrics in Prometheus format for:.
  ///              - Request/response metrics.
  ///              - Error rates and types.
  ///              - Performance metrics.
  ///              - Application health indicators.
  @GET('/metrics')
  Future<void> metricsMetricsGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
