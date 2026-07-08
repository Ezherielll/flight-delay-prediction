import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme.dart';
import 'core/services/router.dart';
import 'viewmodels/settings_viewmodel.dart';

void main() async {
  // Ensure Flutter engine services are bound
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load SharedPreferences before startup
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Inject SharedPreferences into Riverpod dependency tree
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const FlightDelayPredictApp(),
    ),
  );
}

class FlightDelayPredictApp extends ConsumerWidget {
  const FlightDelayPredictApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'Flight Delay Predictor',
      debugShowCheckedModeBanner: false,
      
      // Dynamic Theme settings controlled by settingsProvider state
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      
      // GoRouter Configuration
      routerConfig: router,
    );
  }
}
