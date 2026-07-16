import 'dart:async';
import 'dart:convert';

import 'package:flight_delay_predict/models/info_center_data.dart';
import 'package:flight_delay_predict/viewmodels/locale_viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. State Class
class InfoCenterState {
  InfoCenterState({
    this.data,
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  final InfoCenterData? data;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  InfoCenterState copyWith({
    InfoCenterData? data,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
  }) {
    return InfoCenterState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset if null
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// 2. State Notifier
class InfoCenterNotifier extends Notifier<InfoCenterState> {
  @override
  InfoCenterState build() {
    final locale = ref.watch(localeProvider);
    unawaited(Future.microtask(() => loadData(locale.languageCode)));
    
    final previousState = stateOrNull;
    return InfoCenterState(
      data: previousState?.data,
      isLoading: previousState == null, // Show loading only on first startup
      searchQuery: previousState?.searchQuery ?? '',
    );
  }

  Future<void> loadData([String? languageCode]) async {
    state = state.copyWith(isLoading: true);
    try {
      final code = languageCode ?? ref.read(localeProvider).languageCode;
      // Load static data from JSON asset file based on active language
      final fileName = code == 'id' ? 'info_center_id.json' : 'info_center.json';
      final jsonString = await rootBundle.loadString('assets/data/$fileName');
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final infoCenterData = InfoCenterData.fromJson(jsonMap);

      state = state.copyWith(
        data: infoCenterData,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load Knowledge Base data: $e',
      );
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

// 3. Provider
final infoCenterProvider = NotifierProvider<InfoCenterNotifier, InfoCenterState>(() {
  return InfoCenterNotifier();
});
