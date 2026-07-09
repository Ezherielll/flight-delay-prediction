import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:flight_server_client/flight_server_client.dart';

final serverpodClientProvider = Provider<Client>((ref) {
  // Localhost address pointing to Serverpod port 8080
  return Client(
    'http://localhost:8080/',
    // ignore: deprecated_member_use
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );
});

final sessionManagerProvider = Provider<SessionManager>((ref) {
  throw UnimplementedError('SessionManager must be overridden in ProviderScope');
});
