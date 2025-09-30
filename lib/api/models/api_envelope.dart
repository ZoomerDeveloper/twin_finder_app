// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'response_meta.dart';

part 'api_envelope.g.dart';

/// Generic API envelope that wraps all server responses.
@JsonSerializable(genericArgumentFactories: true)
class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.meta,
  });

  factory ApiEnvelope.fromJson(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiEnvelopeFromJson(json, fromJsonT);

  final bool success;
  final String? message;
  final T? data;
  final dynamic errors;
  final ResponseMeta? meta;

  Map<String, Object?> toJson(Object? Function(T value) toJsonT) =>
      _$ApiEnvelopeToJson(this, toJsonT);
}


