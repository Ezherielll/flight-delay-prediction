import 'dart:async';

import 'package:flight_delay_predict/core/services/auth_service.dart';
import 'package:flight_delay_predict/core/services/serverpod_client.dart';
import 'package:flight_delay_predict/models/user_role.dart';
import 'package:flight_delay_predict/viewmodels/settings_viewmodel.dart';
import 'package:flight_server_client/flight_server_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

class AuthState {
  AuthState({
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.role = UserRoleType.amc,
  });

  final bool isAuthenticated;
  final UserInfo? user;
  final bool isLoading;
  final String? errorMessage;
  final UserRoleType role;

  bool get isAdmin => role == UserRoleType.admin;

  AuthState copyWith({
    bool? isAuthenticated,
    UserInfo? user,
    bool? isLoading,
    String? errorMessage,
    UserRoleType? role,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset if null
      role: role ?? this.role,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  late final AuthService _authService;
  late final Client _client;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    _client = ref.watch(serverpodClientProvider);

    // Add listener to SessionManager updates (automatic session updates)
    _authService.sessionManager.addListener(_onSessionChanged);
    ref.onDispose(() {
      _authService.sessionManager.removeListener(_onSessionChanged);
    });

    // If already signed in, fetch role
    if (_authService.isSignedIn) {
      unawaited(_fetchRole());
    }

    return AuthState(
      isAuthenticated: _authService.isSignedIn,
      user: _authService.sessionManager.signedInUser,
    );
  }

  void _onSessionChanged() {
    final isSignedIn = _authService.isSignedIn;
    state = AuthState(
      isAuthenticated: isSignedIn,
      user: _authService.sessionManager.signedInUser,
    );
    if (isSignedIn) {
      unawaited(_fetchRole());
    }
  }

  /// Fetch the user's role from the server and update state.
  Future<void> _fetchRole() async {
    try {
      final userRole = await _client.userRole.getMyRole();
      state = state.copyWith(
        role: UserRoleType.fromString(userRole.role),
      );
    } on Exception catch (_) {
      // If fetching role fails, default to amc
      state = state.copyWith(role: UserRoleType.amc);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
        // Fetch role after successful sign in
        await _fetchRole();
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid email or password',
        );
      }
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> registerRequest(String username, String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _authService.createAccountRequest(username, email, password);
      state = state.copyWith(isLoading: false);
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> confirmRegistration(String email, String code) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authService.confirmRegistration(email, code);
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid verification code',
        );
      }
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _authService.signOut();
      if (!success) {
        // If server sign out failed, force local sign out
        await _authService.sessionManager.keyManager.remove();
        final prefs = ref.read(sharedPreferencesProvider);
        final runMode = _authService.sessionManager.keyManager.runMode;
        await prefs.remove('serverpod_userinfo_key_$runMode');
        await prefs.remove('serverpod_userinfo_key_${runMode}_version');
        
        // Try to refresh session to clear in-memory _signedInUser
        try {
          await _authService.sessionManager.refreshSession();
        } on Exception catch (_) {}
      }
      state = AuthState(isAuthenticated: false);
    } on Exception catch (_) {
      // Force local sign out on any exception
      try {
        await _authService.sessionManager.keyManager.remove();
        final prefs = ref.read(sharedPreferencesProvider);
        final runMode = _authService.sessionManager.keyManager.runMode;
        await prefs.remove('serverpod_userinfo_key_$runMode');
        await prefs.remove('serverpod_userinfo_key_${runMode}_version');
        await _authService.sessionManager.refreshSession();
      } on Exception catch (_) {}
      state = AuthState(isAuthenticated: false);
    }
  }

  void clearError() {
    state = state.copyWith();
  }
}

final authProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
