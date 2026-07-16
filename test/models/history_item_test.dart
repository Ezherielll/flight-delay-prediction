import 'dart:convert';

import 'package:flight_delay_predict/models/history_item.dart';
import 'package:flight_delay_predict/models/prediction_request.dart';
import 'package:flight_delay_predict/models/prediction_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HistoryItem', () {
    // ---------------------------------------------------------------
    // Fixture helpers
    // ---------------------------------------------------------------
    PredictionRequest sampleRequest() => PredictionRequest(
          airline: 'GA',
          movementType: 'departure',
          fltType: 'schedule',
          date: '2025-08-21',
          hour: 14,
          temperature2m: 28,
          relativeHumidity2m: 70,
          rain: 0,
          surfacePressure: 1010,
          cloudCover: 40,
          cloudCoverLow: 10,
          cloudCoverMid: 20,
          cloudCoverHigh: 30,
          windSpeed10m: 10,
          windSpeed100m: 15,
          windDirection10m: 180,
          windDirection100m: 180,
          windGusts10m: 12,
        );

    PredictionResponse sampleResponse() => PredictionResponse(
          prediction: 'Delayed',
          classValue: 1,
          probability: 0.78,
          confidence: 'High',
          threshold: 0.45,
        );

    HistoryItem createSample() => HistoryItem(
          request: sampleRequest(),
          response: sampleResponse(),
          timestamp: DateTime.parse('2025-08-21T14:30:00.000'),
        );

    // ---------------------------------------------------------------
    // Constructor tests
    // ---------------------------------------------------------------
    group('constructor', () {
      test('stores request, response, and timestamp correctly', () {
        final item = createSample();

        expect(item.request.airline, 'GA');
        expect(item.response.prediction, 'Delayed');
        expect(item.timestamp, DateTime.parse('2025-08-21T14:30:00.000'));
      });
    });

    // ---------------------------------------------------------------
    // toJson tests
    // ---------------------------------------------------------------
    group('toJson', () {
      test('produces map with request, response, and timestamp keys', () {
        final json = createSample().toJson();

        expect(json.containsKey('request'), isTrue);
        expect(json.containsKey('response'), isTrue);
        expect(json.containsKey('timestamp'), isTrue);
      });

      test('timestamp is serialized as ISO 8601 string', () {
        final json = createSample().toJson();
        final ts = json['timestamp'] as String;

        // Should be parseable back to DateTime
        expect(() => DateTime.parse(ts), returnsNormally);
        expect(DateTime.parse(ts).year, 2025);
        expect(DateTime.parse(ts).month, 8);
        expect(DateTime.parse(ts).day, 21);
      });

      test('nested request json has correct snake_case keys', () {
        final json = createSample().toJson();
        final reqJson = json['request'] as Map<String, dynamic>;

        expect(reqJson['airline'], 'GA');
        expect(reqJson['movement_type'], 'departure');
        expect(reqJson['temperature_2m'], 28.0);
      });

      test('nested response json has correct keys', () {
        final json = createSample().toJson();
        final respJson = json['response'] as Map<String, dynamic>;

        expect(respJson['prediction'], 'Delayed');
        expect(respJson['class'], 1);
        expect(respJson['probability'], 0.78);
      });
    });

    // ---------------------------------------------------------------
    // fromJson tests
    // ---------------------------------------------------------------
    group('fromJson', () {
      test('restores all nested objects from json', () {
        final json = createSample().toJson();
        final restored = HistoryItem.fromJson(json);

        expect(restored.request.airline, 'GA');
        expect(restored.request.movementType, 'departure');
        expect(restored.response.prediction, 'Delayed');
        expect(restored.response.classValue, 1);
        expect(restored.response.probability, 0.78);
        expect(restored.timestamp, DateTime.parse('2025-08-21T14:30:00.000'));
      });
    });

    // ---------------------------------------------------------------
    // JSON string round-trip (simulates SharedPreferences storage)
    // ---------------------------------------------------------------
    group('JSON string round-trip', () {
      test('survives jsonEncode → jsonDecode cycle', () {
        final original = createSample();

        // Simulate what prediction_viewmodel does: encode to string, decode back
        final jsonString = jsonEncode(original.toJson());
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final restored = HistoryItem.fromJson(decoded);

        expect(restored.request.airline, original.request.airline);
        expect(restored.request.date, original.request.date);
        expect(restored.request.temperature2m, original.request.temperature2m);
        expect(restored.response.prediction, original.response.prediction);
        expect(restored.response.probability, original.response.probability);
        expect(restored.timestamp, original.timestamp);
      });
    });
  });
}
