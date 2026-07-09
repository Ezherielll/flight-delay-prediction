import 'package:flutter_test/flutter_test.dart';
import 'package:flight_delay_predict/viewmodels/settings_viewmodel.dart';
import 'package:flight_delay_predict/viewmodels/prediction_viewmodel.dart';
import 'package:flight_delay_predict/models/prediction_request.dart';
import 'package:flight_delay_predict/models/prediction_response.dart';
import 'package:flight_delay_predict/models/history_item.dart';

void main() {
  // =================================================================
  // SettingsState unit tests
  // =================================================================
  group('SettingsState', () {
    group('constructor', () {
      test('stores required fields', () {
        final state = SettingsState(
          isDarkMode: true,
          baseUrl: 'http://localhost:8000',
        );

        expect(state.isDarkMode, isTrue);
        expect(state.baseUrl, 'http://localhost:8000');
        expect(state.isTestingConnection, isFalse);
        expect(state.isConnected, isNull);
        expect(state.connectionErrorMessage, isNull);
      });
    });

    group('copyWith', () {
      late SettingsState base;

      setUp(() {
        base = SettingsState(
          isDarkMode: false,
          baseUrl: 'http://example.com',
        );
      });

      test('copies isDarkMode only', () {
        final updated = base.copyWith(isDarkMode: true);
        expect(updated.isDarkMode, isTrue);
        expect(updated.baseUrl, 'http://example.com');
      });

      test('copies baseUrl only', () {
        final updated = base.copyWith(baseUrl: 'http://new.com');
        expect(updated.baseUrl, 'http://new.com');
        expect(updated.isDarkMode, isFalse);
      });

      test('copies isTestingConnection', () {
        final updated = base.copyWith(isTestingConnection: true);
        expect(updated.isTestingConnection, isTrue);
      });

      test('allows isConnected to be set to null explicitly', () {
        // First set to true
        final connected = base.copyWith(isConnected: true);
        expect(connected.isConnected, isTrue);

        // Then reset to null — this is intentional behavior per the code comment
        final reset = connected.copyWith(isConnected: null);
        expect(reset.isConnected, isNull);
      });

      test('allows connectionErrorMessage to be set and cleared', () {
        final withError = base.copyWith(
          connectionErrorMessage: 'Timeout',
        );
        expect(withError.connectionErrorMessage, 'Timeout');

        final cleared = withError.copyWith(connectionErrorMessage: null);
        expect(cleared.connectionErrorMessage, isNull);
      });

      test('preserves all fields when no arguments given', () {
        final state = SettingsState(
          isDarkMode: true,
          baseUrl: 'http://test.com',
          isTestingConnection: true,
          isConnected: true,
          connectionErrorMessage: 'ok',
        );

        final copy = state.copyWith();
        expect(copy.isDarkMode, isTrue);
        expect(copy.baseUrl, 'http://test.com');
        expect(copy.isTestingConnection, isTrue);
        // isConnected is NOT preserved — it explicitly uses the parameter value
        // (null by default), which is by design
        expect(copy.isConnected, isNull);
        expect(copy.connectionErrorMessage, isNull);
      });
    });
  });

  // =================================================================
  // PredictionState unit tests
  // =================================================================
  group('PredictionState', () {
    PredictionRequest sampleRequest() => PredictionRequest(
          airline: 'GA',
          movementType: 'departure',
          fltType: 'schedule',
          date: '2025-01-01',
          hour: 10,
          temperature2m: 28.0,
          relativeHumidity2m: 70.0,
          rain: 0.0,
          surfacePressure: 1010.0,
          cloudCover: 40.0,
          cloudCoverLow: 10.0,
          cloudCoverMid: 20.0,
          cloudCoverHigh: 30.0,
          windSpeed10m: 10.0,
          windSpeed100m: 15.0,
          windDirection10m: 180.0,
          windDirection100m: 180.0,
          windGusts10m: 12.0,
        );

    PredictionResponse sampleResponse() => PredictionResponse(
          prediction: 'On-Time',
          classValue: 0,
          probability: 0.2,
          confidence: 'Low',
          threshold: 0.5,
        );

    group('constructor defaults', () {
      test('isLoading defaults to false', () {
        final state = PredictionState();
        expect(state.isLoading, isFalse);
      });

      test('errorMessage defaults to null', () {
        final state = PredictionState();
        expect(state.errorMessage, isNull);
      });

      test('latestRequest defaults to null', () {
        final state = PredictionState();
        expect(state.latestRequest, isNull);
      });

      test('latestResponse defaults to null', () {
        final state = PredictionState();
        expect(state.latestResponse, isNull);
      });

      test('history defaults to empty list', () {
        final state = PredictionState();
        expect(state.history, isEmpty);
      });
    });

    group('copyWith', () {
      test('copies isLoading', () {
        final state = PredictionState();
        final updated = state.copyWith(isLoading: true);
        expect(updated.isLoading, isTrue);
      });

      test('copies errorMessage and can reset to null', () {
        final state = PredictionState();
        final withError = state.copyWith(errorMessage: 'Network error');
        expect(withError.errorMessage, 'Network error');

        // errorMessage intentionally allows explicit null reset
        final cleared = withError.copyWith(errorMessage: null);
        expect(cleared.errorMessage, isNull);
      });

      test('copies latestRequest', () {
        final state = PredictionState();
        final req = sampleRequest();
        final updated = state.copyWith(latestRequest: req);
        expect(updated.latestRequest?.airline, 'GA');
      });

      test('copies latestResponse', () {
        final state = PredictionState();
        final resp = sampleResponse();
        final updated = state.copyWith(latestResponse: resp);
        expect(updated.latestResponse?.prediction, 'On-Time');
      });

      test('copies history list', () {
        final state = PredictionState();
        final historyItem = HistoryItem(
          request: sampleRequest(),
          response: sampleResponse(),
          timestamp: DateTime.now(),
        );

        final updated = state.copyWith(history: [historyItem]);
        expect(updated.history.length, 1);
        expect(updated.history[0].request.airline, 'GA');
      });

      test('preserves latestRequest when not specified', () {
        final req = sampleRequest();
        final state = PredictionState(latestRequest: req);
        final updated = state.copyWith(isLoading: true);
        expect(updated.latestRequest?.airline, 'GA');
      });

      test('preserves history when not specified', () {
        final historyItem = HistoryItem(
          request: sampleRequest(),
          response: sampleResponse(),
          timestamp: DateTime.now(),
        );
        final state = PredictionState(history: [historyItem]);
        final updated = state.copyWith(isLoading: true);
        expect(updated.history.length, 1);
      });
    });
  });
}
