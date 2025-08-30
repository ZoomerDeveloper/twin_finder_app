// lib/features/auth/logic/auth_state.dart

part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final UserProfileResponse me;
  AuthAuthenticated(this.me);
  @override
  List<Object?> get props => [me];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthEmailCodeSent extends AuthState {
  final String email;
  AuthEmailCodeSent({required this.email});
  @override
  List<Object?> get props => [email];
}

final class AuthFailure extends AuthState {
  final dynamic message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

final class AuthNeedsProfileSetup extends AuthState {}

final class AuthNeedsProfileSetupWithData extends AuthState {
  final UserProfileResponse profile;
  AuthNeedsProfileSetupWithData(this.profile);
  @override
  List<Object?> get props => [profile];
}

final class AuthProfileSetupComplete extends AuthState {}

final class AuthProfileUpdateFailed extends AuthState {
  final String message;
  final String? fieldName;
  AuthProfileUpdateFailed(this.message, {this.fieldName});
  @override
  List<Object?> get props => [message, fieldName];
}
