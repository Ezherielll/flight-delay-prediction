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
      body: state.history.isEmpty
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
