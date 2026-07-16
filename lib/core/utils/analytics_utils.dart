import 'package:flight_server_client/flight_server_client.dart';

class AnalyticsSummary {
  final int totalPredictions;
  final double delayRate; // 0.0 to 1.0
  final int uniqueUsers;
  final int todayPredictions;

  AnalyticsSummary({
    required this.totalPredictions,
    required this.delayRate,
    required this.uniqueUsers,
    required this.todayPredictions,
  });
}

class AnalyticsUtils {
  /// Computes summary stats from bulk prediction records
  static AnalyticsSummary computeSummary(List<PredictionRecord> records) {
    if (records.isEmpty) {
      return AnalyticsSummary(
        totalPredictions: 0,
        delayRate: 0.0,
        uniqueUsers: 0,
        todayPredictions: 0,
      );
    }

    final total = records.length;
    final delayedCount = records.where((r) => r.prediction.toLowerCase() == 'delayed').length;
    final usersSet = records.map((r) => r.userInfoId).toSet();

    final now = DateTime.now();
    final todayCount = records.where((r) {
      final localCreated = r.createdAt.toLocal();
      return localCreated.year == now.year &&
          localCreated.month == now.month &&
          localCreated.day == now.day;
    }).length;

    return AnalyticsSummary(
      totalPredictions: total,
      delayRate: delayedCount / total,
      uniqueUsers: usersSet.length,
      todayPredictions: todayCount,
    );
  }

  /// Computes total predictions by airline (delayed vs on-time)
  /// Returns Map of Airline -> { 'delayed': count, 'ontime': count }
  static Map<String, Map<String, int>> delayByAirline(List<PredictionRecord> records) {
    final Map<String, Map<String, int>> result = {};

    for (final r in records) {
      final airline = r.airline.trim().toUpperCase();
      if (airline.isEmpty) continue;

      if (!result.containsKey(airline)) {
        result[airline] = {'delayed': 0, 'ontime': 0};
      }

      final isDelayed = r.prediction.toLowerCase() == 'delayed';
      if (isDelayed) {
        result[airline]!['delayed'] = result[airline]!['delayed']! + 1;
      } else {
        result[airline]!['ontime'] = result[airline]!['ontime']! + 1;
      }
    }

    return result;
  }

  /// Computes daily trend of predictions for the last 7 days (including today)
  /// Returns Map of DateString (MM/dd) -> { 'delayed': count, 'ontime': count }
  static Map<String, Map<String, int>> dailyTrend(List<PredictionRecord> records) {
    final Map<String, Map<String, int>> result = {};
    final now = DateTime.now();

    // Initialize map for the last 7 days with zero values
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
      result[dateKey] = {'delayed': 0, 'ontime': 0};
    }

    for (final r in records) {
      final localCreated = r.createdAt.toLocal();
      // Date key in format MM/dd
      final dateKey = '${localCreated.month.toString().padLeft(2, '0')}/${localCreated.day.toString().padLeft(2, '0')}';

      if (result.containsKey(dateKey)) {
        final isDelayed = r.prediction.toLowerCase() == 'delayed';
        if (isDelayed) {
          result[dateKey]!['delayed'] = result[dateKey]!['delayed']! + 1;
        } else {
          result[dateKey]!['ontime'] = result[dateKey]!['ontime']! + 1;
        }
      }
    }

    return result;
  }

  /// Computes distribution of confidence levels: High, Medium, Low
  static Map<String, int> confidenceDistribution(List<PredictionRecord> records) {
    final Map<String, int> result = {'High': 0, 'Medium': 0, 'Low': 0};

    for (final r in records) {
      final confidence = r.confidence.trim();
      if (confidence.toLowerCase() == 'high') {
        result['High'] = result['High']! + 1;
      } else if (confidence.toLowerCase() == 'medium') {
        result['Medium'] = result['Medium']! + 1;
      } else if (confidence.toLowerCase() == 'low') {
        result['Low'] = result['Low']! + 1;
      }
    }

    return result;
  }
}
