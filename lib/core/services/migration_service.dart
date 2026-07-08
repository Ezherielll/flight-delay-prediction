import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import '../../models/history_item.dart';
import '../database/app_database.dart';

class MigrationService {
  final SharedPreferences _prefs;
  final AppDatabase _db;

  static const String _keyHistory = 'prediction_history';
  static const String _keyMigrated = 'history_db_migrated';

  MigrationService(this._prefs, this._db);

  Future<void> checkAndMigrate() async {
    final isMigrated = _prefs.getBool(_keyMigrated) ?? false;
    if (isMigrated) return;

    final rawList = _prefs.getStringList(_keyHistory);
    if (rawList == null || rawList.isEmpty) {
      await _prefs.setBool(_keyMigrated, true);
      return;
    }

    for (final itemStr in rawList) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(itemStr);
        final item = HistoryItem.fromJson(jsonMap);

        await _db.into(_db.predictionHistory).insert(
          PredictionHistoryCompanion.insert(
            airline: item.request.airline,
            movementType: item.request.movementType,
            fltType: item.request.fltType,
            origin: Value(item.request.origin),
            destination: Value(item.request.destination),
            flightDate: DateTime.parse(item.request.date),
            flightHour: item.request.hour,
            temperature: item.request.temperature2m,
            rain: item.request.rain,
            cloudCover: item.request.cloudCover,
            prediction: item.response.prediction,
            predictedClass: item.response.classValue,
            probability: item.response.probability,
            confidence: item.response.confidence,
            threshold: item.response.threshold,
            createdAt: item.timestamp,
          ),
        );
      } catch (_) {
        // Skip corrupt entries
      }
    }

    // Set migration flag and remove old data
    await _prefs.setBool(_keyMigrated, true);
    await _prefs.remove(_keyHistory);
  }
}
