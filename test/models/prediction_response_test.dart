import 'package:flutter_test/flutter_test.dart';
import 'package:flight_delay_predict/models/prediction_response.dart';

void main() {
  group('PredictionResponse', () {
    // ---------------------------------------------------------------
    // Constructor tests
    // ---------------------------------------------------------------
    group('constructor', () {
      test('stores all fields correctly', () {
        final resp = PredictionResponse(
          prediction: 'Delayed',
          classValue: 1,
          probability: 0.82,
          confidence: 'High',
          threshold: 0.45,
        );

        expect(resp.prediction, 'Delayed');
        expect(resp.classValue, 1);
        expect(resp.probability, 0.82);
        expect(resp.confidence, 'High');
        expect(resp.threshold, 0.45);
      });

      test('stores on-time prediction correctly', () {
        final resp = PredictionResponse(
          prediction: 'On-Time',
          classValue: 0,
          probability: 0.15,
          confidence: 'Low',
          threshold: 0.45,
        );

        expect(resp.prediction, 'On-Time');
        expect(resp.classValue, 0);
        expect(resp.probability, 0.15);
        expect(resp.confidence, 'Low');
      });
    });

    // ---------------------------------------------------------------
    // fromJson tests
    // ---------------------------------------------------------------
    group('fromJson', () {
      test('parses standard API response correctly', () {
        final json = {
          'prediction': 'Delayed',
          'class': 1,
          'probability': 0.78,
          'confidence': 'High',
          'threshold': 0.45,
        };

        final resp = PredictionResponse.fromJson(json);

        expect(resp.prediction, 'Delayed');
        expect(resp.classValue, 1);
        expect(resp.probability, 0.78);
        expect(resp.confidence, 'High');
        expect(resp.threshold, 0.45);
      });

      test('handles classValue key fallback', () {
        // The fromJson uses: json['class'] ?? json['classValue'] ?? 0
        final json = {
          'prediction': 'On-Time',
          'classValue': 0,
          'probability': 0.2,
          'confidence': 'Medium',
          'threshold': 0.5,
        };

        final resp = PredictionResponse.fromJson(json);
        expect(resp.classValue, 0);
      });

      test('defaults classValue to 0 when both keys are missing', () {
        final json = {
          'prediction': 'On-Time',
          'probability': 0.1,
          'confidence': 'Low',
          'threshold': 0.5,
        };

        final resp = PredictionResponse.fromJson(json);
        expect(resp.classValue, 0);
      });

      test('handles integer probability via num coercion', () {
        final json = {
          'prediction': 'Delayed',
          'class': 1,
          'probability': 1, // int, not double
          'confidence': 'High',
          'threshold': 0,
        };

        final resp = PredictionResponse.fromJson(json);
        expect(resp.probability, 1.0);
        expect(resp.threshold, 0.0);
      });
    });

    // ---------------------------------------------------------------
    // toJson tests
    // ---------------------------------------------------------------
    group('toJson', () {
      test('produces correct json map', () {
        final resp = PredictionResponse(
          prediction: 'Delayed',
          classValue: 1,
          probability: 0.67,
          confidence: 'Medium',
          threshold: 0.45,
        );
        final json = resp.toJson();

        expect(json['prediction'], 'Delayed');
        expect(json['class'], 1);
        expect(json['probability'], 0.67);
        expect(json['confidence'], 'Medium');
        expect(json['threshold'], 0.45);
        expect(json.keys.length, 5);
      });
    });

    // ---------------------------------------------------------------
    // Round-trip tests
    // ---------------------------------------------------------------
    group('serialization round-trip', () {
      test('toJson then fromJson preserves all data', () {
        final original = PredictionResponse(
          prediction: 'On-Time',
          classValue: 0,
          probability: 0.22,
          confidence: 'Low',
          threshold: 0.5,
        );

        final restored = PredictionResponse.fromJson(original.toJson());

        expect(restored.prediction, original.prediction);
        expect(restored.classValue, original.classValue);
        expect(restored.probability, original.probability);
        expect(restored.confidence, original.confidence);
        expect(restored.threshold, original.threshold);
      });
    });
  });
}
