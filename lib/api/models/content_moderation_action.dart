// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'content_moderation_action.g.dart';

/// Content moderation action.
@JsonSerializable()
class ContentModerationAction {
  const ContentModerationAction({
    required this.actionType,
    required this.reason,
    this.durationDays,
    this.notes,
  });
  
  factory ContentModerationAction.fromJson(Map<String, Object?> json) => _$ContentModerationActionFromJson(json);
  
  /// Action type
  @JsonKey(name: 'action_type')
  final String actionType;

  /// Action duration in days
  @JsonKey(name: 'duration_days')
  final int? durationDays;

  /// Action reason
  final String reason;

  /// Additional notes
  final String? notes;

  Map<String, Object?> toJson() => _$ContentModerationActionToJson(this);
}
