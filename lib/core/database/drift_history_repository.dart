import 'package:drift/drift.dart';
import '../../models/history_item.dart';
import '../../models/prediction_request.dart';
import '../../models/prediction_response.dart';
import 'app_database.dart';
import 'history_repository.dart';

class DriftHistoryRepository implements HistoryRepository {
  final AppDatabase _db;

  DriftHistoryRepository(this._db);

  @override
  Future<void> init() async {
    // Database initializes lazily, no initialization step needed here.
  }

  @override
  Future<List<HistoryItem>> getAll({
    String? airline,
    String? prediction,
    int? limit,
    int offset = 0,
  }) async {
    final query = _db.select(_db.predictionHistory);

    if (airline != null && airline.isNotEmpty) {
      query.where((t) => t.airline.equals(airline.toUpperCase()));
    }
    if (prediction != null && prediction.isNotEmpty) {
      query.where((t) => t.prediction.equals(prediction));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
    ]);

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    final rows = await query.get();

    return rows.map((row) {
      return HistoryItem(
        timestamp: row.createdAt,
        request: PredictionRequest(
          airline: row.airline,
          movementType: row.movementType,
          fltType: row.fltType,
          date: row.flightDate.toIso8601String().split('T')[0],
          hour: row.flightHour,
          temperature2m: row.temperature,
          relativeHumidity2m: 0.0, // Defaults not stored in mini-snapshot
          rain: row.rain,
          surfacePressure: 0.0,
          cloudCover: row.cloudCover,
          cloudCoverLow: 0.0,
          cloudCoverMid: 0.0,
          cloudCoverHigh: 0.0,
          windSpeed10m: 0.0,
          windSpeed100m: 0.0,
          windDirection10m: 0.0,
          windDirection100m: 0.0,
          windGusts10m: 0.0,
          acType: null,
          origin: row.origin,
          destination: row.destination,
          weatherCode: null,
        ),
        response: PredictionResponse(
          prediction: row.prediction,
          classValue: row.predictedClass,
          probability: row.probability,
          confidence: row.confidence,
          threshold: row.threshold,
        ),
      );
    }).toList();
  }

  @override
  Future<int> getCount({String? airline, String? prediction}) async {
    final countExpr = _db.predictionHistory.id.count();
    final query = _db.selectOnly(_db.predictionHistory)..addColumns([countExpr]);

    if (airline != null && airline.isNotEmpty) {
      query.where(_db.predictionHistory.airline.equals(airline.toUpperCase()));
    }
    if (prediction != null && prediction.isNotEmpty) {
      query.where(_db.predictionHistory.prediction.equals(prediction));
    }

    final result = await query.map((row) => row.read(countExpr)).getSingle();
    return result ?? 0;
  }

  @override
  Future<void> insert(HistoryItem item) async {
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
  }

  @override
  Future<void> deleteAt(int index) async {
    // Delete by offset/index in Drift is best done by retrieving the target id
    final list = await getAll(limit: 1, offset: index);
    if (list.isNotEmpty) {
      // In Drift, let's delete by matching timestamp or custom logic.
      // Better to delete where exact fields match.
      final target = list.first;
      await (_db.delete(_db.predictionHistory)
            ..where((t) => t.createdAt.equals(target.timestamp)))
          .go();
    }
  }

  @override
  Future<void> deleteById(String id) async {
    await (_db.delete(_db.predictionHistory)
          ..where((t) => t.serverId.equals(id)))
        .go();
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.predictionHistory).go();
  }

  @override
  Future<void> close() async {
    await _db.close();
  }
}
