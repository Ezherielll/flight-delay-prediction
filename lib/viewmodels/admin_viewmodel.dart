import 'package:flight_delay_predict/core/services/serverpod_client.dart';
import 'package:flight_server_client/flight_server_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the Admin Panel
class AdminState {
  AdminState({
    this.users = const [],
    this.allPredictions = const [],
    this.isLoadingUsers = false,
    this.isLoadingPredictions = false,
    this.errorMessage,
  });

  final List<UserRole> users;
  final List<PredictionRecord> allPredictions;
  final bool isLoadingUsers;
  final bool isLoadingPredictions;
  final String? errorMessage;

  AdminState copyWith({
    List<UserRole>? users,
    List<PredictionRecord>? allPredictions,
    bool? isLoadingUsers,
    bool? isLoadingPredictions,
    String? errorMessage,
  }) {
    return AdminState(
      users: users ?? this.users,
      allPredictions: allPredictions ?? this.allPredictions,
      isLoadingUsers: isLoadingUsers ?? this.isLoadingUsers,
      isLoadingPredictions: isLoadingPredictions ?? this.isLoadingPredictions,
      errorMessage: errorMessage,
    );
  }
}

class AdminViewModel extends Notifier<AdminState> {
  late final Client _client;

  @override
  AdminState build() {
    _client = ref.watch(serverpodClientProvider);
    return AdminState();
  }

  /// Fetch all users with their roles.
  Future<void> fetchAllUsers() async {
    state = state.copyWith(isLoadingUsers: true);
    try {
      final users = await _client.userRole.getAllUsers();
      state = state.copyWith(users: users, isLoadingUsers: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoadingUsers: false,
        errorMessage: 'Failed to fetch users: ${e.toString().replaceAll("Exception: ", "")}',
      );
    }
  }

  /// Fetch all prediction records from all users.
  Future<void> fetchAllPredictions() async {
    state = state.copyWith(isLoadingPredictions: true);
    try {
      final predictions = await _client.predictionHistory.getAllPredictions();
      state = state.copyWith(
        allPredictions: predictions,
        isLoadingPredictions: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoadingPredictions: false,
        errorMessage: 'Failed to fetch predictions: ${e.toString().replaceAll("Exception: ", "")}',
      );
    }
  }

  /// Update a user's role.
  Future<bool> updateRole(int targetUserId, String newRole) async {
    try {
      await _client.userRole.updateUserRole(targetUserId, newRole);
      await fetchAllUsers(); // Refresh the list
      return true;
    } on Exception catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Delete a user.
  Future<bool> deleteUser(int targetUserId) async {
    try {
      await _client.userRole.deleteUser(targetUserId);
      await fetchAllUsers(); // Refresh the list
      return true;
    } on Exception catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Clear the error message.
  void clearError() {
    state = state.copyWith();
  }
}

final adminProvider = NotifierProvider<AdminViewModel, AdminState>(() {
  return AdminViewModel();
});
