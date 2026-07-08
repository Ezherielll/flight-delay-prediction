import 'package:shared_preferences/shared_preferences.dart';

/// StorageService — hanya untuk settings/preferences.
/// 
/// Riwayat prediksi sekarang dikelola oleh [HistoryRepository]
/// di `core/database/history_repository.dart`.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String _keyBaseUrl = 'base_url';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLocale = 'app_locale';

  // Base API URL
  String getBaseUrl() {
    return _prefs.getString(_keyBaseUrl) ?? 'http://127.0.0.1:8000';
  }

  Future<void> setBaseUrl(String url) async {
    await _prefs.setString(_keyBaseUrl, url);
  }

  // Locale Preference
  String? getLocale() {
    return _prefs.getString(_keyLocale);
  }

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(_keyLocale, languageCode);
  }

  // Dark Mode Preference
  bool isDarkMode() {
    return _prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool enabled) async {
    await _prefs.setBool(_keyDarkMode, enabled);
  }
}
