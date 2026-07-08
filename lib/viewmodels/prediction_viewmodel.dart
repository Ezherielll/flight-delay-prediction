import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_viewmodel.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../models/prediction_request.dart';
import '../models/prediction_response.dart';
import '../models/history_item.dart';

// 1. Prediction State Class
class PredictionState {
  final bool isLoading;
  final String? errorMessage;
  final PredictionRequest? latestRequest;
  final PredictionResponse? latestResponse;
  final List<HistoryItem> history;

  PredictionState({
    this.isLoading = false,
    this.errorMessage,
    this.latestRequest,
    this.latestResponse,
    this.history = const [],
  });

  PredictionState copyWith({
    bool? isLoading,
    String? errorMessage,
    PredictionRequest? latestRequest,
    PredictionResponse? latestResponse,
    List<HistoryItem>? history,
  }) {
    return PredictionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Explicitly reset if null
      latestRequest: latestRequest ?? this.latestRequest,
      latestResponse: latestResponse ?? this.latestResponse,
      history: history ?? this.history,
    );
  }
}

// 2. Prediction Notifier
class PredictionNotifier extends StateNotifier<PredictionState> {
  final ApiService _apiService;
  final StorageService _storageService;

  PredictionNotifier(this._apiService, this._storageService)
      : super(PredictionState()) {
    _loadHistory();
  }

  // Load history from shared preferences
  void _loadHistory() {
    try {
      final rawList = _storageService.getHistoryRaw();
      final historyItems = rawList.map((itemStr) {
        final Map<String, dynamic> jsonMap = jsonDecode(itemStr);
        return HistoryItem.fromJson(jsonMap);
      }).toList();
      state = state.copyWith(history: historyItems);
    } catch (_) {
      // In case of parsing errors, initialize with empty
      state = state.copyWith(history: []);
    }
  }

  // Perform prediction request
  Future<bool> runPrediction(PredictionRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final responseMap = await _apiService.predict(request.toJson());
      final predictionResponse = PredictionResponse.fromJson(responseMap);

      // Create history item
      final historyItem = HistoryItem(
        request: request,
        response: predictionResponse,
        timestamp: DateTime.now(),
      );

      // Save to SharedPreferences
      final historyJson = jsonEncode(historyItem.toJson());
      await _storageService.addHistoryItem(historyJson);

      // Update state with result and updated history list
      final updatedHistory = List<HistoryItem>.from(state.history)..insert(0, historyItem);

      state = state.copyWith(
        isLoading: false,
        latestRequest: request,
        latestResponse: predictionResponse,
        history: updatedHistory,
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
  void setLatestPrediction(PredictionRequest request, PredictionResponse response) {
    state = state.copyWith(latestRequest: request, latestResponse: response);
  }

  // Remove single history item
  Future<void> deleteHistoryItem(int index) async {
    await _storageService.removeHistoryItem(index);
    final updatedList = List<HistoryItem>.from(state.history)..removeAt(index);
    state = state.copyWith(history: updatedList);
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    await _storageService.clearHistory();
    state = state.copyWith(history: []);
  }
}

// 3. Prediction Provider
final predictionProvider = StateNotifierProvider<PredictionNotifier, PredictionState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return PredictionNotifier(apiService, storageService);
});
