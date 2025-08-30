// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/photo_delete_response.dart';
import '../models/photo_response.dart';
import '../models/photo_upload_response.dart';

part 'photos_client.g.dart';

@RestApi()
abstract class PhotosClient {
  factory PhotosClient(Dio dio, {String? baseUrl}) = _PhotosClient;

  /// Upload Photo.
  ///
  /// Upload a new photo for the current user.
  @MultiPart()
  @POST('/api/v1/photos/upload')
  Future<PhotoUploadResponse> uploadPhotoApiV1PhotosUploadPost({
    @Part(name: 'file') required MultipartFile file,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Photo.
  ///
  /// Get a photo by ID for the current user.
  @GET('/api/v1/photos/{photo_id}')
  Future<PhotoResponse> getPhotoApiV1PhotosPhotoIdGet({
    @Path('photo_id') required String photoId,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Delete Photo.
  ///
  /// Delete a photo by ID for the current user.
  @DELETE('/api/v1/photos/{photo_id}')
  Future<PhotoDeleteResponse> deletePhotoApiV1PhotosPhotoIdDelete({
    @Path('photo_id') required String photoId,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
