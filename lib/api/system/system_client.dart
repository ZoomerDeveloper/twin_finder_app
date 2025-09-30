// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'system_client.g.dart';

@RestApi()
abstract class SystemClient {
  factory SystemClient(Dio dio, {String? baseUrl}) = _SystemClient;

  /// ML & Vector health.
  ///
  /// Status of ONNX embedding model and ChromaDB connectivity.
  @GET('/api/v1/system/ml-health')
  Future<void> mlHealthApiV1SystemMlHealthGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Debug ChromaDB.
  ///
  /// Debug endpoint to inspect ChromaDB embeddings and metadata.
  @GET('/api/v1/system/debug/chromadb')
  Future<void> debugChromadbApiV1SystemDebugChromadbGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
