import 'dart:async';

import 'package:flight_delay_predict/core/services/serverpod_client.dart';
import 'package:flight_delay_predict/models/history_item.dart';
import 'package:flight_delay_predict/models/prediction_request.dart';
import 'package:flight_delay_predict/models/prediction_response.dart';
import 'package:flight_delay_predict/viewmodels/settings_viewmodel.dart';
import 'package:flight_server_client/flight_server_client.dart' as sp;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Prediction State Class
class PredictionState {
  PredictionState({
    this.isLoading = false,
    this.errorMessage,
    this.latestRequest,
    this.latestResponse,
    this.history = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final PredictionRequest? latestRequest;
  final PredictionResponse? latestResponse;
  final List<HistoryItem> history;

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
class PredictionNotifier extends Notifier<PredictionState> {
  @override
  PredictionState build() {
    final state = PredictionState();
    unawaited(_loadHistory());
    return state;
  }

  // Helper mapping: Serverpod model to local app model
  HistoryItem _toHistoryItem(sp.PredictionRecord record) {
    return HistoryItem(
      id: record.id,
      request: PredictionRequest(
        airline: record.airline,
        movementType: record.movementType,
        fltType: record.fltType,
        date: record.date,
        hour: record.hour,
        temperature2m: record.temperature2m,
        relativeHumidity2m: record.relativeHumidity2m,
        rain: record.rain,
        surfacePressure: record.surfacePressure,
        cloudCover: record.cloudCover,
        cloudCoverLow: record.cloudCoverLow,
        cloudCoverMid: record.cloudCoverMid,
        cloudCoverHigh: record.cloudCoverHigh,
        windSpeed10m: record.windSpeed10m,
        windSpeed100m: record.windSpeed100m,
        windDirection10m: record.windDirection10m,
        windDirection100m: record.windDirection100m,
        windGusts10m: record.windGusts10m,
        acType: record.acType,
        origin: record.origin,
        destination: record.destination,
        weatherCode: record.weatherCode,
      ),
      response: PredictionResponse(
        prediction: record.prediction,
        classValue: record.prediction.toLowerCase() == 'delayed' ? 1 : 0,
        probability: record.probability,
        confidence: record.confidence,
        threshold: record.threshold,
      ),
      timestamp: record.createdAt,
    );
  }

  // Helper mapping: Local app model to Serverpod model
  sp.PredictionRecord _toPredictionRecord(HistoryItem item) {
    return sp.PredictionRecord(
      userInfoId: 0, // Assigned on Serverpod server-side using current session
      airline: item.request.airline,
      movementType: item.request.movementType,
      fltType: item.request.fltType,
      date: item.request.date,
      hour: item.request.hour,
      temperature2m: item.request.temperature2m,
      relativeHumidity2m: item.request.relativeHumidity2m,
      rain: item.request.rain,
      surfacePressure: item.request.surfacePressure,
      cloudCover: item.request.cloudCover,
      cloudCoverLow: item.request.cloudCoverLow,
      cloudCoverMid: item.request.cloudCoverMid,
      cloudCoverHigh: item.request.cloudCoverHigh,
      windSpeed10m: item.request.windSpeed10m,
      windSpeed100m: item.request.windSpeed100m,
      windDirection10m: item.request.windDirection10m,
      windDirection100m: item.request.windDirection100m,
      windGusts10m: item.request.windGusts10m,
      acType: item.request.acType,
      origin: item.request.origin,
      destination: item.request.destination,
      weatherCode: item.request.weatherCode,
      prediction: item.response.prediction,
      probability: item.response.probability,
      confidence: item.response.confidence,
      threshold: item.response.threshold,
      createdAt: item.timestamp,
    );
  }

  // Load history from Serverpod server
  Future<void> _loadHistory() async {
    try {
      final client = ref.read(serverpodClientProvider);
      final records = await client.predictionHistory.getUserHistory();
      final historyItems = records.map(_toHistoryItem).toList();
      state = state.copyWith(history: historyItems);
    } on Exception catch (_) {
      // In case of error (e.g. backend offline), initialize empty list
      state = state.copyWith(history: []);
    }
  }

  // Perform prediction request
  Future<bool> runPrediction(PredictionRequest request) async {
    final apiService = ref.read(apiServiceProvider);
    state = state.copyWith(isLoading: true);

    try {
      // 1. Get prediction from local ML Python FastAPI server
      final responseMap = await apiService.predict(request.toJson());
      final predictionResponse = PredictionResponse.fromJson(responseMap);

      // Create local history item
      final historyItem = HistoryItem(
        request: request,
        response: predictionResponse,
        timestamp: DateTime.now(),
      );

      // 2. Save history item directly to Serverpod cloud database
      final client = ref.read(serverpodClientProvider);
      final record = _toPredictionRecord(historyItem);
      final savedRecord = await client.predictionHistory.savePrediction(record);
      final savedHistoryItem = _toHistoryItem(savedRecord);

      // Update state with result and updated history list
      final updatedHistory = List<HistoryItem>.from(state.history)
        ..insert(0, savedHistoryItem);

      state = state.copyWith(
        isLoading: false,
        latestRequest: request,
        latestResponse: predictionResponse,
        history: updatedHistory,
      );

      return true;
    } on Exception catch (e) {
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

  // Remove single history item from Serverpod database
  Future<void> deleteHistoryItem(int index) async {
    final item = state.history[index];
    if (item.id != null) {
      try {
        final client = ref.read(serverpodClientProvider);
        await client.predictionHistory.deletePrediction(item.id!);
      } on Exception catch (_) {
        state = state.copyWith(errorMessage: 'Failed to delete prediction from server');
        return;
      }
    }

    final updatedList = List<HistoryItem>.from(state.history)..removeAt(index);
    state = state.copyWith(history: updatedList);
  }

  // Clear all history from Serverpod database
  Future<void> clearAllHistory() async {
    try {
      final client = ref.read(serverpodClientProvider);
      await client.predictionHistory.clearHistory();
      state = state.copyWith(history: []);
    } on Exception catch (_) {
      state = state.copyWith(errorMessage: 'Failed to clear history on server');
    }
  }
}

// 3. Prediction Provider
final predictionProvider =
    NotifierProvider<PredictionNotifier, PredictionState>(() {
      return PredictionNotifier();
    });
