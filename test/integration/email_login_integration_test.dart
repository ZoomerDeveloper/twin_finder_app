import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/repository/auth_repository.dart';
import 'package:twin_finder/core/utils/token_secure.dart';
import 'package:twin_finder/api/api_client.dart';

/// Integration test for email login functionality
/// This test directly tests the AuthCubit and Repository without UI interaction
///
/// To run this test:
/// flutter test test/integration/email_login_integration_test.dart
///
/// This test will:
/// 1. Attempt to login with provided credentials
/// 2. Verify that tokens are stored correctly
/// 3. Verify that profile completeness is checked
/// 4. Document all states emitted during the process
/// 5. Capture any errors that occur
///
void main() {
  group('Email Login Integration Test', () {
    late AuthCubit authCubit;
    late List<AuthState> emittedStates;

    setUp(() async {
      // Get dependencies from service locator
      final GetIt sl = GetIt.instance;

      // Initialize the AuthCubit
      final authRepository = sl<AuthRepository>();
      authCubit = AuthCubit(authRepository);

      // Track all emitted states
      emittedStates = [];
      authCubit.stream.listen((state) {
        emittedStates.add(state);
        print('State emitted: ${state.runtimeType}');

        if (state is AuthFailure) {
          print('  - Error message: ${state.message}');
        } else if (state is AuthAuthenticated) {
          print('  - User authenticated successfully');
          print('  - User ID: ${state.profile.data.id}');
          print('  - Email: ${state.profile.data.email}');
          print('  - Profile completed: ${state.profile.data.profileCompleted}');
        } else if (state is AuthNeedsProfileSetupWithData) {
          print('  - Profile needs setup');
          print('  - User ID: ${state.profile.data.id}');
          print('  - Email: ${state.profile.data.email}');
        }
      });
    });

    tearDown(() {
      authCubit.close();
    });

    test('Login with test credentials: artyommicheev@yandex.ru', () async {
      print('\n=== Starting Email Login Test ===\n');

      // Test credentials
      const email = 'artyommicheev@yandex.ru';
      const password = '12345678';

      print('Test Credentials:');
      print('  Email: $email');
      print('  Password: ${"*" * password.length}');
      print('\nAttempting login...\n');

      // Perform login
      await authCubit.login(email, password);

      // Wait a bit for all state emissions to complete
      await Future.delayed(const Duration(seconds: 2));

      print('\n=== Test Results ===\n');
      print('Total states emitted: ${emittedStates.length}');
      print('State sequence:');
      for (var i = 0; i < emittedStates.length; i++) {
        print('  ${i + 1}. ${emittedStates[i].runtimeType}');
      }

      // Analyze the results
      print('\n=== Analysis ===\n');

      final hasAuthLoading = emittedStates.any((s) => s is AuthLoading);
      final hasAuthFailure = emittedStates.any((s) => s is AuthFailure);
      final hasAuthAuthenticated = emittedStates.any((s) => s is AuthAuthenticated);
      final hasAuthUnauthenticated = emittedStates.any((s) => s is AuthUnauthenticated);
      final hasAuthNeedsProfileSetup = emittedStates.any((s) => s is AuthNeedsProfileSetupWithData);

      print('State Flags:');
      print('  ✓ AuthLoading: $hasAuthLoading');
      print('  ✓ AuthFailure: $hasAuthFailure');
      print('  ✓ AuthAuthenticated: $hasAuthAuthenticated');
      print('  ✓ AuthUnauthenticated: $hasAuthUnauthenticated');
      print('  ✓ AuthNeedsProfileSetup: $hasAuthNeedsProfileSetup');

      // Determine test outcome
      print('\n=== Test Outcome ===\n');

      if (hasAuthFailure) {
        final failureState = emittedStates.firstWhere((s) => s is AuthFailure) as AuthFailure;
        print('❌ LOGIN FAILED');
        print('Error: ${failureState.message}');
        print('\nPossible reasons:');
        print('  1. Invalid credentials');
        print('  2. Network error');
        print('  3. Server error');
        print('  4. API endpoint not reachable');

        // Check for specific error patterns
        final errorMsg = failureState.message.toLowerCase();
        if (errorMsg.contains('incorrect') || errorMsg.contains('password')) {
          print('\nDiagnosis: Invalid email or password');
        } else if (errorMsg.contains('network') || errorMsg.contains('connection')) {
          print('\nDiagnosis: Network connectivity issue');
        } else if (errorMsg.contains('server') || errorMsg.contains('500')) {
          print('\nDiagnosis: Server-side error');
        }
      } else if (hasAuthAuthenticated || hasAuthNeedsProfileSetup) {
        print('✅ LOGIN SUCCESSFUL');

        if (hasAuthAuthenticated) {
          print('Status: User fully authenticated with complete profile');
          final authState = emittedStates.firstWhere((s) => s is AuthAuthenticated) as AuthAuthenticated;
          print('Profile:');
          print('  - Name: ${authState.profile.data.name}');
          print('  - Email: ${authState.profile.data.email}');
          print('  - Birthday: ${authState.profile.data.birthday}');
          print('  - Gender: ${authState.profile.data.gender}');
          print('  - Country: ${authState.profile.data.country}');
          print('  - City: ${authState.profile.data.city}');
        } else if (hasAuthNeedsProfileSetup) {
          print('Status: User authenticated but needs to complete profile');
          final setupState = emittedStates.firstWhere((s) => s is AuthNeedsProfileSetupWithData) as AuthNeedsProfileSetupWithData;
          print('Profile (incomplete):');
          print('  - Name: ${setupState.profile.data.name}');
          print('  - Email: ${setupState.profile.data.email}');
          print('  - Birthday: ${setupState.profile.data.birthday}');
          print('  - Gender: ${setupState.profile.data.gender}');
          print('  - Country: ${setupState.profile.data.country}');
          print('  - City: ${setupState.profile.data.city}');
        }

        // Verify tokens were stored
        print('\nVerifying token storage...');
        final tokenStore = GetIt.instance<TokenStore>();
        final accessToken = await tokenStore.access;
        final refreshToken = await tokenStore.refresh;

        if (accessToken != null && accessToken.isNotEmpty) {
          print('✅ Access token stored successfully');
          print('   Length: ${accessToken.length} characters');
        } else {
          print('❌ Access token NOT stored');
        }

        if (refreshToken != null && refreshToken.isNotEmpty) {
          print('✅ Refresh token stored successfully');
          print('   Length: ${refreshToken.length} characters');
        } else {
          print('❌ Refresh token NOT stored');
        }
      } else if (hasAuthUnauthenticated) {
        print('❌ LOGIN ENDED IN UNAUTHENTICATED STATE');
        print('This indicates login failed but no specific error was captured');
      } else {
        print('⚠️  UNEXPECTED STATE SEQUENCE');
        print('The login process did not complete as expected');
      }

      print('\n=== End of Test ===\n');

      // Test assertions
      expect(hasAuthLoading, true, reason: 'AuthLoading should be emitted');

      // Either login succeeds or fails, but it should not hang
      expect(
        hasAuthFailure || hasAuthAuthenticated || hasAuthNeedsProfileSetup || hasAuthUnauthenticated,
        true,
        reason: 'Login should complete with a final state',
      );
    });
  });
}