// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'device_info_response.g.dart';

/// Response for device detection.
@JsonSerializable()
class DeviceInfoResponse {
  const DeviceInfoResponse({
    required this.isMobile,
    required this.isTablet,
    required this.isPc,
    required this.isTouchCapable,
    required this.isBot,
    required this.osFamily,
    required this.osVersion,
    required this.browserFamily,
    required this.browserVersion,
    required this.deviceFamily,
    required this.deviceBrand,
    required this.deviceModel,
    required this.appStoreUrl,
    required this.platform,
  });
  
  factory DeviceInfoResponse.fromJson(Map<String, Object?> json) => _$DeviceInfoResponseFromJson(json);
  
  /// Whether device is mobile
  @JsonKey(name: 'is_mobile')
  final bool isMobile;

  /// Whether device is tablet
  @JsonKey(name: 'is_tablet')
  final bool isTablet;

  /// Whether device is PC
  @JsonKey(name: 'is_pc')
  final bool isPc;

  /// Whether device supports touch
  @JsonKey(name: 'is_touch_capable')
  final bool isTouchCapable;

  /// Whether request is from a bot
  @JsonKey(name: 'is_bot')
  final bool isBot;

  /// Operating system family
  @JsonKey(name: 'os_family')
  final String osFamily;

  /// Operating system version
  @JsonKey(name: 'os_version')
  final String osVersion;

  /// Browser family
  @JsonKey(name: 'browser_family')
  final String browserFamily;

  /// Browser version
  @JsonKey(name: 'browser_version')
  final String browserVersion;

  /// Device family
  @JsonKey(name: 'device_family')
  final String deviceFamily;

  /// Device brand
  @JsonKey(name: 'device_brand')
  final String deviceBrand;

  /// Device model
  @JsonKey(name: 'device_model')
  final String deviceModel;

  /// App store URL for the platform
  @JsonKey(name: 'app_store_url')
  final String appStoreUrl;

  /// Platform (ios, android, web)
  final String platform;

  Map<String, Object?> toJson() => _$DeviceInfoResponseToJson(this);
}
