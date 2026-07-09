import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flight_delay_predict/core/services/storage_service.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() async {
      // SharedPreferences.setMockInitialValues must be called before getInstance
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
    });

    // ---------------------------------------------------------------
    // Base URL
    // ---------------------------------------------------------------
    group('baseUrl', () {
      test('returns default URL when nothing is saved', () {
        expect(storageService.getBaseUrl(), 'http://127.0.0.1:8000');
      });

      test('saves and retrieves custom URL', () async {
        await storageService.setBaseUrl('http://10.0.2.2:8000');
        expect(storageService.getBaseUrl(), 'http://10.0.2.2:8000');
      });

      test('overwrites previous URL', () async {
        await storageService.setBaseUrl('http://first.com');
        await storageService.setBaseUrl('http://second.com');
        expect(storageService.getBaseUrl(), 'http://second.com');
      });
    });

    // ---------------------------------------------------------------
    // Locale
    // ---------------------------------------------------------------
    group('locale', () {
      test('returns null when no locale is saved', () {
        expect(storageService.getLocale(), isNull);
      });

      test('saves and retrieves locale', () async {
        await storageService.setLocale('id');
        expect(storageService.getLocale(), 'id');
      });

      test('overwrites previous locale', () async {
        await storageService.setLocale('id');
        await storageService.setLocale('en');
        expect(storageService.getLocale(), 'en');
      });
    });

    // ---------------------------------------------------------------
    // Dark mode
    // ---------------------------------------------------------------
    group('darkMode', () {
      test('defaults to false', () {
        expect(storageService.isDarkMode(), isFalse);
      });

      test('saves and retrieves dark mode enabled', () async {
        await storageService.setDarkMode(true);
        expect(storageService.isDarkMode(), isTrue);
      });

      test('can toggle back to false', () async {
        await storageService.setDarkMode(true);
        await storageService.setDarkMode(false);
        expect(storageService.isDarkMode(), isFalse);
      });
    });

    // ---------------------------------------------------------------
    // History
    // ---------------------------------------------------------------
    group('history', () {
      test('returns empty list when no history exists', () {
        expect(storageService.getHistoryRaw(), isEmpty);
      });

      test('addHistoryItem inserts at front (newest first)', () async {
        await storageService.addHistoryItem('{"id": 1}');
        await storageService.addHistoryItem('{"id": 2}');

        final history = storageService.getHistoryRaw();
        expect(history.length, 2);
        expect(history[0], '{"id": 2}'); // newest first
        expect(history[1], '{"id": 1}');
      });

      test('limits history to 50 items', () async {
        // Add 55 items
        for (int i = 0; i < 55; i++) {
          await storageService.addHistoryItem('{"index": $i}');
        }

        final history = storageService.getHistoryRaw();
        expect(history.length, 50);
        // The last added item should be first
        expect(history[0], '{"index": 54}');
      });

      test('removeHistoryItem removes at given index', () async {
        await storageService.addHistoryItem('{"id": "a"}');
        await storageService.addHistoryItem('{"id": "b"}');
        await storageService.addHistoryItem('{"id": "c"}');

        // History order: c, b, a (newest first)
        await storageService.removeHistoryItem(1); // remove "b"

        final history = storageService.getHistoryRaw();
        expect(history.length, 2);
        expect(history[0], '{"id": "c"}');
        expect(history[1], '{"id": "a"}');
      });

      test('removeHistoryItem ignores invalid negative index', () async {
        await storageService.addHistoryItem('{"id": 1}');
        await storageService.removeHistoryItem(-1);

        expect(storageService.getHistoryRaw().length, 1);
      });

      test('removeHistoryItem ignores out-of-bounds index', () async {
        await storageService.addHistoryItem('{"id": 1}');
        await storageService.removeHistoryItem(5);

        expect(storageService.getHistoryRaw().length, 1);
      });

      test('clearHistory removes all items', () async {
        await storageService.addHistoryItem('{"id": 1}');
        await storageService.addHistoryItem('{"id": 2}');
        await storageService.addHistoryItem('{"id": 3}');

        await storageService.clearHistory();
        expect(storageService.getHistoryRaw(), isEmpty);
      });

      test('saveHistoryRaw directly replaces history list', () async {
        await storageService.saveHistoryRaw(['a', 'b', 'c']);

        final history = storageService.getHistoryRaw();
        expect(history, ['a', 'b', 'c']);
      });
    });
  });
}
