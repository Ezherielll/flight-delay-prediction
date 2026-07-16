import 'package:flight_delay_predict/core/services/serverpod_client.dart';
import 'package:flight_server_client/flight_server_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

class AuthService {
  AuthService(this._client, this._sessionManager) {
    _emailAuthController = EmailAuthController(_client.modules.auth);
  }

  final Client _client;
  final SessionManager _sessionManager;
  late final EmailAuthController _emailAuthController;

  SessionManager get sessionManager => _sessionManager;

  // Check if user is signed in
  bool get isSignedIn => _sessionManager.isSignedIn;

  // Sign In
  Future<UserInfo?> signIn(String email, String password) async {
    final userInfo = await _emailAuthController.signIn(email, password);
    return userInfo;
  }

  // Create account request (triggers code console output)
  Future<bool> createAccountRequest(
    String username,
    String email,
    String password,
  ) async {
    return _emailAuthController.createAccountRequest(
      username,
      email,
      password,
    );
  }

  // Verify email & complete registration
  Future<UserInfo?> confirmRegistration(
    String email,
    String verificationCode,
  ) async {
    final userInfo = await _emailAuthController.validateAccount(
      email,
      verificationCode,
    );
    return userInfo;
  }

  // Sign Out
  Future<bool> signOut() async {
    return _sessionManager.signOutDevice();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final sessionManager = ref.watch(sessionManagerProvider);
  return AuthService(client, sessionManager);
});
