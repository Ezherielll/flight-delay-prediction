import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:flight_server_client/flight_server_client.dart';

import 'core/theme/theme.dart';
import 'core/services/router.dart';
import 'core/services/serverpod_client.dart';
import 'viewmodels/settings_viewmodel.dart';

import 'package:flight_delay_predict/l10n/app_localizations.dart';
import 'viewmodels/locale_viewmodel.dart';

void main() async {
  // Ensure Flutter engine services are bound
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load SharedPreferences before startup
  final sharedPrefs = await SharedPreferences.getInstance();

  // Initialize Serverpod Client & SessionManager
  final client = Client(
    'http://localhost:8080/',
    // ignore: deprecated_member_use
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );
  final sessionManager = SessionManager(caller: client.modules.auth);
  await sessionManager.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Inject SharedPreferences into Riverpod dependency tree
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        serverpodClientProvider.overrideWithValue(client),
        sessionManagerProvider.overrideWithValue(sessionManager),
      ],
      child: const FlightDelayPredictApp(),
    ),
  );
}

class FlightDelayPredictApp extends ConsumerWidget {
  const FlightDelayPredictApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = ref.watch(localeProvider);

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Flight Delay Predictor',
      debugShowCheckedModeBanner: false,

      // Dynamic Theme settings controlled by settingsProvider state
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Localization Configuration
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // GoRouter Configuration
      routerConfig: router,
    );
  }
}
