import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import '../core/services/auth_service.dart';
import 'settings_viewmodel.dart';

class AuthState {
  final bool isAuthenticated;
  final UserInfo? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserInfo? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset if null
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);

    // Add listener to SessionManager updates (automatic session updates)
    _authService.sessionManager.addListener(_onSessionChanged);
    ref.onDispose(() {
      _authService.sessionManager.removeListener(_onSessionChanged);
    });

    return AuthState(
      isAuthenticated: _authService.isSignedIn,
      user: _authService.sessionManager.signedInUser,
    );
  }

  void _onSessionChanged() {
    state = AuthState(
      isAuthenticated: _authService.isSignedIn,
      user: _authService.sessionManager.signedInUser,
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid email or password',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> registerRequest(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _authService.createAccountRequest(username, email, password);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> confirmRegistration(String email, String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
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
        } catch (_) {}
      }
      state = AuthState(isAuthenticated: false);
    } catch (e) {
      // Force local sign out on any exception
      try {
        await _authService.sessionManager.keyManager.remove();
        final prefs = ref.read(sharedPreferencesProvider);
        final runMode = _authService.sessionManager.keyManager.runMode;
        await prefs.remove('serverpod_userinfo_key_$runMode');
        await prefs.remove('serverpod_userinfo_key_${runMode}_version');
        await _authService.sessionManager.refreshSession();
      } catch (_) {}
      state = AuthState(isAuthenticated: false);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
