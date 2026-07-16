import 'package:flight_delay_predict/models/prediction_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PredictionRequest', () {
    // ---------------------------------------------------------------
    // Fixture helpers
    // ---------------------------------------------------------------
    PredictionRequest createSample({
      String airline = 'GA',
      String movementType = 'departure',
      String fltType = 'schedule',
      String date = '2025-08-21',
      int hour = 14,
      double temperature2m = 28,
      double relativeHumidity2m = 70,
      double rain = 0,
      double surfacePressure = 1010,
      double cloudCover = 40,
      double cloudCoverLow = 10,
      double cloudCoverMid = 20,
      double cloudCoverHigh = 30,
      double windSpeed10m = 10,
      double windSpeed100m = 15,
      double windDirection10m = 180,
      double windDirection100m = 180,
      double windGusts10m = 12,
      String? acType,
      String? origin,
      String? destination,
      int? weatherCode,
    }) {
      return PredictionRequest(
        airline: airline,
        movementType: movementType,
        fltType: fltType,
        date: date,
        hour: hour,
        temperature2m: temperature2m,
        relativeHumidity2m: relativeHumidity2m,
        rain: rain,
        surfacePressure: surfacePressure,
        cloudCover: cloudCover,
        cloudCoverLow: cloudCoverLow,
        cloudCoverMid: cloudCoverMid,
        cloudCoverHigh: cloudCoverHigh,
        windSpeed10m: windSpeed10m,
        windSpeed100m: windSpeed100m,
        windDirection10m: windDirection10m,
        windDirection100m: windDirection100m,
        windGusts10m: windGusts10m,
        acType: acType,
        origin: origin,
        destination: destination,
        weatherCode: weatherCode,
      );
    }

    // ---------------------------------------------------------------
    // Constructor tests
    // ---------------------------------------------------------------
    group('constructor', () {
      test('stores all required fields correctly', () {
        final req = createSample();

        expect(req.airline, 'GA');
        expect(req.movementType, 'departure');
        expect(req.fltType, 'schedule');
        expect(req.date, '2025-08-21');
        expect(req.hour, 14);
        expect(req.temperature2m, 28.0);
        expect(req.relativeHumidity2m, 70.0);
        expect(req.rain, 0.0);
        expect(req.surfacePressure, 1010.0);
        expect(req.cloudCover, 40.0);
        expect(req.cloudCoverLow, 10.0);
        expect(req.cloudCoverMid, 20.0);
        expect(req.cloudCoverHigh, 30.0);
        expect(req.windSpeed10m, 10.0);
        expect(req.windSpeed100m, 15.0);
        expect(req.windDirection10m, 180.0);
        expect(req.windDirection100m, 180.0);
        expect(req.windGusts10m, 12.0);
      });

      test('optional fields default to null', () {
        final req = createSample();

        expect(req.acType, isNull);
        expect(req.origin, isNull);
        expect(req.destination, isNull);
        expect(req.weatherCode, isNull);
      });

      test('optional fields are stored when provided', () {
        final req = createSample(
          acType: 'B737',
          origin: 'KNO',
          destination: 'CGK',
          weatherCode: 61,
        );

        expect(req.acType, 'B737');
        expect(req.origin, 'KNO');
        expect(req.destination, 'CGK');
        expect(req.weatherCode, 61);
      });
    });

    // ---------------------------------------------------------------
    // toJson tests
    // ---------------------------------------------------------------
    group('toJson', () {
      test('converts required fields with correct snake_case keys', () {
        final req = createSample();
        final json = req.toJson();

        expect(json['airline'], 'GA');
        expect(json['movement_type'], 'departure');
        expect(json['flt_type'], 'schedule');
        expect(json['date'], '2025-08-21');
        expect(json['hour'], 14);
        expect(json['temperature_2m'], 28.0);
        expect(json['relative_humidity_2m'], 70.0);
        expect(json['rain'], 0.0);
        expect(json['surface_pressure'], 1010.0);
        expect(json['cloud_cover'], 40.0);
        expect(json['cloud_cover_low'], 10.0);
        expect(json['cloud_cover_mid'], 20.0);
        expect(json['cloud_cover_high'], 30.0);
        expect(json['wind_speed_10m'], 10.0);
        expect(json['wind_speed_100m'], 15.0);
        expect(json['wind_direction_10m'], 180.0);
        expect(json['wind_direction_100m'], 180.0);
        expect(json['wind_gusts_10m'], 12.0);
      });

      test('excludes null optional fields from json', () {
        final req = createSample();
        final json = req.toJson();

        expect(json.containsKey('ac_type'), isFalse);
        expect(json.containsKey('origin'), isFalse);
        expect(json.containsKey('destination'), isFalse);
        expect(json.containsKey('weather_code'), isFalse);
      });

      test('includes optional fields when present', () {
        final req = createSample(
          acType: 'A320',
          origin: 'KNO',
          destination: 'CGK',
          weatherCode: 3,
        );
        final json = req.toJson();

        expect(json['ac_type'], 'A320');
        expect(json['origin'], 'KNO');
        expect(json['destination'], 'CGK');
        expect(json['weather_code'], 3);
      });

      test('json has exactly 18 keys when no optional fields', () {
        final json = createSample().toJson();
        // airline, movement_type, flt_type, date, hour, + 13 weather fields
        expect(json.keys.length, 18);
      });
    });

    // ---------------------------------------------------------------
    // fromJson tests
    // ---------------------------------------------------------------
    group('fromJson', () {
      test('parses all required fields correctly', () {
        final json = {
          'airline': 'QG',
          'movement_type': 'arrival',
          'flt_type': 'charter',
          'date': '2025-12-01',
          'hour': 8,
          'temperature_2m': 25.5,
          'relative_humidity_2m': 88,
          'rain': 5,
          'surface_pressure': 1005,
          'cloud_cover': 90,
          'cloud_cover_low': 70,
          'cloud_cover_mid': 60,
          'cloud_cover_high': 80,
          'wind_speed_10m': 20,
          'wind_speed_100m': 30,
          'wind_direction_10m': 270,
          'wind_direction_100m': 265,
          'wind_gusts_10m': 40,
        };

        final req = PredictionRequest.fromJson(json);

        expect(req.airline, 'QG');
        expect(req.movementType, 'arrival');
        expect(req.fltType, 'charter');
        expect(req.date, '2025-12-01');
        expect(req.hour, 8);
        expect(req.temperature2m, 25.5);
        expect(req.relativeHumidity2m, 88.0);
        expect(req.rain, 5.0);
        expect(req.surfacePressure, 1005.0);
        expect(req.cloudCover, 90.0);
        expect(req.cloudCoverLow, 70.0);
        expect(req.cloudCoverMid, 60.0);
        expect(req.cloudCoverHigh, 80.0);
        expect(req.windSpeed10m, 20.0);
        expect(req.windSpeed100m, 30.0);
        expect(req.windDirection10m, 270.0);
        expect(req.windDirection100m, 265.0);
        expect(req.windGusts10m, 40.0);
      });

      test('handles integer values for numeric fields (num coercion)', () {
        final json = {
          'airline': 'SJ',
          'movement_type': 'departure',
          'flt_type': 'schedule',
          'date': '2025-01-01',
          'hour': 0,
          'temperature_2m': 30, // int, not double
          'relative_humidity_2m': 50,
          'rain': 0,
          'surface_pressure': 1013,
          'cloud_cover': 0,
          'cloud_cover_low': 0,
          'cloud_cover_mid': 0,
          'cloud_cover_high': 0,
          'wind_speed_10m': 5,
          'wind_speed_100m': 8,
          'wind_direction_10m': 90,
          'wind_direction_100m': 90,
          'wind_gusts_10m': 6,
        };

        final req = PredictionRequest.fromJson(json);
        expect(req.temperature2m, 30.0);
        expect(req.rain, 0.0);
        expect(req.surfacePressure, 1013.0);
      });

      test('parses optional fields when present', () {
        final json = createSample(
          acType: 'B738',
          origin: 'SUB',
          destination: 'DPS',
          weatherCode: 95,
        ).toJson();

        final req = PredictionRequest.fromJson(json);
        expect(req.acType, 'B738');
        expect(req.origin, 'SUB');
        expect(req.destination, 'DPS');
        expect(req.weatherCode, 95);
      });
    });

    // ---------------------------------------------------------------
    // Round-trip (toJson → fromJson) tests
    // ---------------------------------------------------------------
    group('serialization round-trip', () {
      test('toJson then fromJson produces equivalent object', () {
        final original = createSample(
          airline: 'JT',
          acType: 'A320',
          origin: 'KNO',
          destination: 'CGK',
          weatherCode: 61,
        );

        final restored = PredictionRequest.fromJson(original.toJson());

        expect(restored.airline, original.airline);
        expect(restored.movementType, original.movementType);
        expect(restored.fltType, original.fltType);
        expect(restored.date, original.date);
        expect(restored.hour, original.hour);
        expect(restored.temperature2m, original.temperature2m);
        expect(restored.relativeHumidity2m, original.relativeHumidity2m);
        expect(restored.rain, original.rain);
        expect(restored.surfacePressure, original.surfacePressure);
        expect(restored.cloudCover, original.cloudCover);
        expect(restored.cloudCoverLow, original.cloudCoverLow);
        expect(restored.cloudCoverMid, original.cloudCoverMid);
        expect(restored.cloudCoverHigh, original.cloudCoverHigh);
        expect(restored.windSpeed10m, original.windSpeed10m);
        expect(restored.windSpeed100m, original.windSpeed100m);
        expect(restored.windDirection10m, original.windDirection10m);
        expect(restored.windDirection100m, original.windDirection100m);
        expect(restored.windGusts10m, original.windGusts10m);
        expect(restored.acType, original.acType);
        expect(restored.origin, original.origin);
        expect(restored.destination, original.destination);
        expect(restored.weatherCode, original.weatherCode);
      });
    });
  });
}
