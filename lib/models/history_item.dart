import 'prediction_request.dart';
import 'prediction_response.dart';

class HistoryItem {
  final int? id;
  final PredictionRequest request;
  final PredictionResponse response;
  final DateTime timestamp;

  HistoryItem({
    this.id,
    required this.request,
    required this.response,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'request': request.toJson(),
      'response': response.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as int?,
      request: PredictionRequest.fromJson(json['request'] as Map<String, dynamic>),
      response: PredictionResponse.fromJson(json['response'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
