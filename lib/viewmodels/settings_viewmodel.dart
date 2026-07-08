import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Dependency Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiService(storageService);
});

// 2. Settings State Class
class SettingsState {
  final bool isDarkMode;
  final String baseUrl;
  final bool isTestingConnection;
  final bool? isConnected;
  final String? connectionErrorMessage;

  SettingsState({
    required this.isDarkMode,
    required this.baseUrl,
    this.isTestingConnection = false,
    this.isConnected,
    this.connectionErrorMessage,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? baseUrl,
    bool? isTestingConnection,
    bool? isConnected,
    String? connectionErrorMessage,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      baseUrl: baseUrl ?? this.baseUrl,
      isTestingConnection: isTestingConnection ?? this.isTestingConnection,
      isConnected: isConnected, // Allowed to set to null
      connectionErrorMessage: connectionErrorMessage,
    );
  }
}

// 3. Settings Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storageService;
  final ApiService _apiService;

  SettingsNotifier(this._storageService, this._apiService)
      : super(SettingsState(
          isDarkMode: _storageService.isDarkMode(),
          baseUrl: _storageService.getBaseUrl(),
        ));

  Future<void> toggleTheme(bool enabled) async {
    await _storageService.setDarkMode(enabled);
    state = state.copyWith(isDarkMode: enabled);
  }

  Future<void> updateBaseUrl(String url) async {
    String formattedUrl = url.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'http://$formattedUrl';
    }
    // Remove trailing slash if present
    if (formattedUrl.endsWith('/')) {
      formattedUrl = formattedUrl.substring(0, formattedUrl.length - 1);
    }
    await _storageService.setBaseUrl(formattedUrl);
    state = state.copyWith(baseUrl: formattedUrl, isConnected: null);
  }

  Future<void> testConnection() async {
    state = state.copyWith(isTestingConnection: true, isConnected: null);
    try {
      final success = await _apiService.checkHealth();
      state = state.copyWith(
        isTestingConnection: false,
        isConnected: success,
        connectionErrorMessage: success ? null : 'Could not reach server health endpoint.',
      );
    } catch (e) {
      state = state.copyWith(
        isTestingConnection: false,
        isConnected: false,
        connectionErrorMessage: e.toString(),
      );
    }
  }

  void resetConnectionStatus() {
    state = state.copyWith(isConnected: null, connectionErrorMessage: null);
  }
}

// 4. Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return SettingsNotifier(storageService, apiService);
});
