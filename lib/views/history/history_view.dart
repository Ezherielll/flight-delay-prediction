import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/prediction_viewmodel.dart';
import '../../widgets/prediction_card.dart';
import '../../core/theme/theme.dart';
import '../../widgets/app_drawer.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(predictionProvider);
    final notifier = ref.read(predictionProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(l10n?.history ?? 'Estimation History'),
        actions: [
          if (state.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: AppTheme.dangerColor),
              tooltip: l10n?.clearAllHistory ?? 'Clear All History',
              onPressed: () => _confirmClearAll(context, notifier),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Airline Filter Input
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n?.appTitle != null ? 'Filter Airline (e.g. GA)' : 'Filter Airline...',
                      prefixIcon: const Icon(Icons.flight),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      final airline = value.trim().isEmpty ? null : value.trim().toUpperCase();
                      notifier.applyFilter(
                        airline: airline,
                        prediction: state.filterPrediction,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Prediction Status Dropdown
                DropdownButton<String>(
                  value: state.filterPrediction,
                  hint: const Text('All Status'),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.filter_list),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All Status'),
                    ),
                    DropdownMenuItem(
                      value: 'Delayed',
                      child: Text('Delayed'),
                    ),
                    DropdownMenuItem(
                      value: 'On-Time',
                      child: Text('On-Time'),
                    ),
                  ],
                  onChanged: (value) {
                    notifier.applyFilter(
                      airline: state.filterAirline,
                      prediction: value,
                    );
                  },
                ),
              ],
            ),
          ),
          if (state.filterAirline != null || state.filterPrediction != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    'Active Filters: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (state.filterAirline != null)
                    Chip(
                      label: Text('Airline: ${state.filterAirline}'),
                      onDeleted: () {
                        notifier.applyFilter(
                          airline: null,
                          prediction: state.filterPrediction,
                        );
                      },
                    ),
                  const SizedBox(width: 4),
                  if (state.filterPrediction != null)
                    Chip(
                      label: Text('Status: ${state.filterPrediction}'),
                      onDeleted: () {
                        notifier.applyFilter(
                          airline: state.filterAirline,
                          prediction: null,
                        );
                      },
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => notifier.clearFilters(),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: state.history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 72,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n?.noHistoryRecorded ?? 'No history recorded yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n?.runDelayEstimationToLog ?? 'Run a flight delay estimation to log search data.',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.push('/predict'),
                          child: Text(l10n?.startPrediction ?? 'Start Prediction'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final item = state.history[index];
                      
                      // Wrap in Dismissible for smooth swipe-to-delete animation
                      return Dismissible(
                        key: Key('history_${item.timestamp.millisecondsSinceEpoch}_$index'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await notifier.deleteHistoryItem(index);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n?.historyItemRemoved ?? 'History item removed'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        background: Container(
                          color: AppTheme.dangerColor,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        child: PredictionCard(
                          item: item,
                          onDelete: () async {
                            await notifier.deleteHistoryItem(index);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n?.historyItemRemoved ?? 'History item removed'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          onTap: () {
                            // Set as the current result and navigate to ResultView
                            ref.read(predictionProvider.notifier).setLatestPrediction(
                                  item.request,
                                  item.response,
                                );
                            context.push('/result');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, PredictionNotifier notifier) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.confirmClearAllTitle ?? 'Clear All History?'),
        content: Text(
            l10n?.confirmClearAllDesc ?? 'This action will permanently delete all saved prediction inputs and outcomes from local storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await notifier.clearAllHistory();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n?.historyCleared ?? 'History cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n?.clearAll ?? 'Clear All'),
          ),
        ],
      ),
    );
  }
}
