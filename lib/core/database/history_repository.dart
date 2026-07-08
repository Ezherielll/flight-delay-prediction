/// Database helper untuk menyimpan riwayat prediksi secara lokal
/// menggunakan sqflite (mobile/desktop) dengan fallback ke SharedPreferences (web).
///
/// Menyediakan operasi CRUD untuk tabel prediction_history.
library;

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/history_item.dart';

import 'app_database.dart';
import 'drift_history_repository.dart';

/// Abstract repository interface untuk history storage
abstract class HistoryRepository {
  Future<void> init();
  Future<List<HistoryItem>> getAll({String? airline, String? prediction, int? limit, int offset = 0});
  Future<int> getCount({String? airline, String? prediction});
  Future<void> insert(HistoryItem item);
  Future<void> deleteAt(int index);
  Future<void> deleteById(String id);
  Future<void> clearAll();
  Future<void> close();
}

/// Implementasi SharedPreferences untuk web dan sebagai fallback universal.
/// Menyimpan data sebagai JSON string list di SharedPreferences.
class SharedPrefsHistoryRepository implements HistoryRepository {
  final SharedPreferences _prefs;
  static const String _keyHistory = 'prediction_history';
  static const String _migrationFlag = 'history_db_migrated';
  static const int _maxItems = 200; // Increased from 50

  SharedPrefsHistoryRepository(this._prefs);

  @override
  Future<void> init() async {
    // No-op for SharedPreferences
  }

  @override
  Future<List<HistoryItem>> getAll({
    String? airline,
    String? prediction,
    int? limit,
    int offset = 0,
  }) async {
    final rawList = _prefs.getStringList(_keyHistory) ?? [];
    List<HistoryItem> items = [];

    for (final itemStr in rawList) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(itemStr);
        final item = HistoryItem.fromJson(jsonMap);

        // Apply filters
        if (airline != null && item.request.airline.toUpperCase() != airline.toUpperCase()) {
          continue;
        }
        if (prediction != null && item.response.prediction != prediction) {
          continue;
        }

        items.add(item);
      } catch (_) {
        // Skip malformed entries
      }
    }

    // Apply pagination
    if (offset >= items.length) return [];
    final end = limit != null ? (offset + limit).clamp(0, items.length) : items.length;
    return items.sublist(offset, end);
  }

  @override
  Future<int> getCount({String? airline, String? prediction}) async {
    final items = await getAll(airline: airline, prediction: prediction);
    return items.length;
  }

  @override
  Future<void> insert(HistoryItem item) async {
    final list = _prefs.getStringList(_keyHistory) ?? [];
    final itemJson = jsonEncode(item.toJson());

    // Insert at front (newest first)
    list.insert(0, itemJson);

    // Enforce max items
    if (list.length > _maxItems) {
      list.removeRange(_maxItems, list.length);
    }

    await _prefs.setStringList(_keyHistory, list);
  }

  @override
  Future<void> deleteAt(int index) async {
    final list = _prefs.getStringList(_keyHistory) ?? [];
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await _prefs.setStringList(_keyHistory, list);
    }
  }

  @override
  Future<void> deleteById(String id) async {
    // SharedPreferences doesn't have IDs, so this is a no-op
    // For web, items don't have server IDs anyway
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(_keyHistory);
  }

  @override
  Future<void> close() async {
    // No-op for SharedPreferences
  }

  /// Check if data has been migrated already
  bool get isMigrated => _prefs.getBool(_migrationFlag) ?? false;

  /// Mark data as migrated
  Future<void> markMigrated() async {
    await _prefs.setBool(_migrationFlag, true);
  }

  /// Get raw JSON list for migration
  List<String> getRawList() {
    return _prefs.getStringList(_keyHistory) ?? [];
  }
}

class HistoryRepositoryFactory {
  static HistoryRepository create(SharedPreferences prefs, AppDatabase db) {
    if (kIsWeb) {
      return SharedPrefsHistoryRepository(prefs);
    }
    return DriftHistoryRepository(db);
  }
}
