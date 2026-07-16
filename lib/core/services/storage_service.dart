import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyBaseUrl = 'base_url';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyHistory = 'prediction_history';
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

  Future<void> setDarkMode({required bool enabled}) async {
    await _prefs.setBool(_keyDarkMode, enabled);
  }

  // Prediction History
  List<String> getHistoryRaw() {
    return _prefs.getStringList(_keyHistory) ?? [];
  }

  Future<void> saveHistoryRaw(List<String> historyList) async {
    await _prefs.setStringList(_keyHistory, historyList);
  }

  Future<void> addHistoryItem(String itemJson) async {
    final list = getHistoryRaw()..insert(0, itemJson);
    // Limit history to 50 items
    if (list.length > 50) {
      list.removeRange(50, list.length);
    }
    await saveHistoryRaw(list);
  }

  Future<void> removeHistoryItem(int index) async {
    final list = getHistoryRaw();
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveHistoryRaw(list);
    }
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_keyHistory);
  }
}
