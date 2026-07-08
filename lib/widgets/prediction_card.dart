import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history_item.dart';
import '../core/theme/theme.dart';

class PredictionCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const PredictionCard({
    Key? key,
    required this.item,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDelayed = item.response.classValue == 1;
    final statusColor = isDelayed ? AppTheme.dangerColor : AppTheme.successColor;
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(item.timestamp);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left color accent bar
              Container(
                width: 6,
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flight_takeoff,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item.request.airline} • ${item.request.fltType}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
                            ),
                            child: Text(
                              item.response.prediction,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Probabilitas Delay: ${(item.response.probability * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            'Confidence: ${item.response.confidence}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getConfidenceColor(item.response.confidence),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          if (onDelete != null)
                            GestureDetector(
                              onTap: onDelete,
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: theme.colorScheme.error.withOpacity(0.8),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(String confidence) {
    switch (confidence.toLowerCase()) {
      case 'high':
        return AppTheme.successColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'low':
      default:
        return AppTheme.dangerColor;
    }
  }
}
