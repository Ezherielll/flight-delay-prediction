import 'dart:async';

import 'package:flight_delay_predict/core/services/export_service.dart';
import 'package:flight_delay_predict/core/theme/theme.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import 'package:flight_delay_predict/models/history_item.dart';
import 'package:flight_delay_predict/viewmodels/prediction_viewmodel.dart';
import 'package:flight_delay_predict/widgets/app_drawer.dart';
import 'package:flight_delay_predict/widgets/prediction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          if (state.history.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Export History',
              onPressed: () => _showExportOptions(context, state.history),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: AppTheme.dangerColor),
              tooltip: l10n?.clearAllHistory ?? 'Clear All History',
              onPressed: () => _confirmClearAll(context, notifier),
            ),
          ],
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
                    padding: const EdgeInsets.only(right: 24),
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
                      unawaited(context.push('/result'));
                    },
                  ),
                );
              },
            ),
    );
  }

  void _confirmClearAll(BuildContext context, PredictionNotifier notifier) {
    final l10n = AppLocalizations.of(context);
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n?.confirmClearAllTitle ?? 'Clear All History?'),
          content: Text(
            l10n?.confirmClearAllDesc ??
                'This action will permanently delete all saved prediction '
                'inputs and outcomes from local storage.',
          ),
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
                  SnackBar(
                    content: Text(
                      l10n?.historyCleared ?? 'History cleared successfully',
                    ),
                  ),
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
      ),
    );
  }

  void _showExportOptions(BuildContext context, List<HistoryItem> history) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          final theme = Theme.of(ctx);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Estimation History',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: const Text('Export to CSV (Excel compatible)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    unawaited(ExportService.exportHistoryToCsv(history));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text('Export to PDF (Print-ready)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    unawaited(ExportService.exportHistoryToPdf(history));
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
    );
  }
}
