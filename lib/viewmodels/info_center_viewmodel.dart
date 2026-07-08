import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/info_center_data.dart';

// 1. State Class
class InfoCenterState {
  final InfoCenterData? data;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  InfoCenterState({
    this.data,
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

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
    Future.microtask(() => loadData());
    return InfoCenterState();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Load static data from JSON asset file
      final jsonString = await rootBundle.loadString('assets/data/info_center.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final infoCenterData = InfoCenterData.fromJson(jsonMap);

      state = state.copyWith(
        data: infoCenterData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load Knowledge Base data: ${e.toString()}',
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
