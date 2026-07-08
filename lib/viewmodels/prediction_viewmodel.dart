import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_viewmodel.dart';
import '../models/prediction_request.dart';
import '../models/prediction_response.dart';
import '../models/history_item.dart';
import '../core/database/history_repository.dart';
import '../core/database/app_database.dart';
import '../core/services/migration_service.dart';

// 0. App Database Provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// 1. History Repository Provider
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final db = ref.watch(appDatabaseProvider);
  return HistoryRepositoryFactory.create(prefs, db);
});

// 2. Prediction State Class
class PredictionState {
  final bool isLoading;
  final String? errorMessage;
  final PredictionRequest? latestRequest;
  final PredictionResponse? latestResponse;
  final List<HistoryItem> history;
  final int totalHistoryCount;
  final String? filterAirline;
  final String? filterPrediction;

  PredictionState({
    this.isLoading = false,
    this.errorMessage,
    this.latestRequest,
    this.latestResponse,
    this.history = const [],
    this.totalHistoryCount = 0,
    this.filterAirline,
    this.filterPrediction,
  });

  PredictionState copyWith({
    bool? isLoading,
    String? errorMessage,
    PredictionRequest? latestRequest,
    PredictionResponse? latestResponse,
    List<HistoryItem>? history,
    int? totalHistoryCount,
    String? filterAirline,
    String? filterPrediction,
    bool clearFilters = false,
  }) {
    return PredictionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Explicitly reset if null
      latestRequest: latestRequest ?? this.latestRequest,
      latestResponse: latestResponse ?? this.latestResponse,
      history: history ?? this.history,
      totalHistoryCount: totalHistoryCount ?? this.totalHistoryCount,
      filterAirline: clearFilters ? null : (filterAirline ?? this.filterAirline),
      filterPrediction: clearFilters ? null : (filterPrediction ?? this.filterPrediction),
    );
  }
}

// 3. Prediction Notifier
class PredictionNotifier extends Notifier<PredictionState> {
  @override
  PredictionState build() {
    final state = PredictionState();
    Future.microtask(() async {
      await _runMigration();
      await _loadHistory();
    });
    return state;
  }

  HistoryRepository get _repo => ref.read(historyRepositoryProvider);

  // Run migration on startup
  Future<void> _runMigration() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final db = ref.read(appDatabaseProvider);
      final migrationService = MigrationService(prefs, db);
      await migrationService.checkAndMigrate();
    } catch (_) {
      // Catch and ignore migration failures to avoid app crash
    }
  }

  // Load history from repository
  Future<void> _loadHistory() async {
    try {
      final items = await _repo.getAll(
        airline: state.filterAirline,
        prediction: state.filterPrediction,
      );
      final count = await _repo.getCount(
        airline: state.filterAirline,
        prediction: state.filterPrediction,
      );
      state = state.copyWith(history: items, totalHistoryCount: count);
    } catch (_) {
      // In case of parsing errors, initialize with empty
      state = state.copyWith(history: [], totalHistoryCount: 0);
    }
  }

  // Apply filters and reload history
  Future<void> applyFilter({String? airline, String? prediction}) async {
    state = state.copyWith(
      filterAirline: airline,
      filterPrediction: prediction,
    );
    await _loadHistory();
  }

  // Clear all filters
  Future<void> clearFilters() async {
    state = state.copyWith(clearFilters: true);
    await _loadHistory();
  }

  // Perform prediction request
  Future<bool> runPrediction(PredictionRequest request) async {
    final apiService = ref.read(apiServiceProvider);
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final responseMap = await apiService.predict(request.toJson());
      final predictionResponse = PredictionResponse.fromJson(responseMap);

      // Create history item
      final historyItem = HistoryItem(
        request: request,
        response: predictionResponse,
        timestamp: DateTime.now(),
      );

      // Save to repository (replaces SharedPreferences direct access)
      await _repo.insert(historyItem);

      // Reload history from repository to ensure consistency
      final updatedItems = await _repo.getAll();
      final count = await _repo.getCount();

      state = state.copyWith(
        isLoading: false,
        latestRequest: request,
        latestResponse: predictionResponse,
        history: updatedItems,
        totalHistoryCount: count,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Set active prediction state from history
  void setLatestPrediction(
    PredictionRequest request,
    PredictionResponse response,
  ) {
    state = state.copyWith(latestRequest: request, latestResponse: response);
  }

  // Remove single history item
  Future<void> deleteHistoryItem(int index) async {
    await _repo.deleteAt(index);
    final updatedItems = await _repo.getAll(
      airline: state.filterAirline,
      prediction: state.filterPrediction,
    );
    final count = await _repo.getCount(
      airline: state.filterAirline,
      prediction: state.filterPrediction,
    );
    state = state.copyWith(history: updatedItems, totalHistoryCount: count);
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    await _repo.clearAll();
    state = state.copyWith(history: [], totalHistoryCount: 0);
  }
}

// 4. Prediction Provider
final predictionProvider =
    NotifierProvider<PredictionNotifier, PredictionState>(() {
      return PredictionNotifier();
    });
