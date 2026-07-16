import 'package:flight_delay_predict/models/prediction_request.dart';
import 'package:flight_delay_predict/models/prediction_response.dart';

class HistoryItem {
  HistoryItem({
    required this.request,
    required this.response,
    required this.timestamp,
    this.id,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as int?,
      request: PredictionRequest.fromJson(json['request'] as Map<String, dynamic>),
      response: PredictionResponse.fromJson(json['response'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  final int? id;
  final PredictionRequest request;
  final PredictionResponse response;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'request': request.toJson(),
      'response': response.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
