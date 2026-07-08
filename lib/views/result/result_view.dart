import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../viewmodels/prediction_viewmodel.dart';
import '../../core/theme/theme.dart';

class ResultView extends ConsumerWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final predictionState = ref.watch(predictionProvider);
    
    final request = predictionState.latestRequest;
    final response = predictionState.latestResponse;

    if (request == null || response == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Estimation Result')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No prediction results found.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final isDelayed = response.classValue == 1;
    final statusColor = isDelayed ? AppTheme.dangerColor : AppTheme.successColor;
    final probabilityPercent = (response.probability * 100).toStringAsFixed(1);
    final thresholdPercent = (response.threshold * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // STATUS BLOCK CARD
            Card(
              elevation: 4,
              shadowColor: statusColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: statusColor.withOpacity(0.5), width: 2),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: theme.brightness == Brightness.light
                        ? [Colors.white, statusColor.withOpacity(0.04)]
                        : [theme.cardTheme.color!, statusColor.withOpacity(0.02)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Dynamic Status Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDelayed ? Icons.warning_rounded : Icons.check_circle_rounded,
                        color: statusColor,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isDelayed ? 'DELAY EXPECTED' : 'ON-TIME EXPECTED',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI model prediction for Flight ${request.airline}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(height: 40, thickness: 1.5),

                    // RADIAL GAUGE FOR PROBABILITY
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: response.probability,
                            strokeWidth: 12,
                            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.08),
                            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$probabilityPercent%',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Delay Chance',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // DETAILS ROWS (CONFIDENCE, THRESHOLD)
                    Row(
                      children: [
                        Expanded(
                          child: _buildResultInfoBox(
                            context,
                            'Confidence',
                            response.confidence,
                            _getConfidenceColor(response.confidence),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildResultInfoBox(
                            context,
                            'Decision Threshold',
                            '$thresholdPercent%',
                            theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FLIGHT DETAILS SUMMARY
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flight_takeoff, color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Estimated Parameters',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildParamRow('Airline Code', request.airline),
                    _buildParamRow('Movement Type', request.movementType),
                    _buildParamRow('Flight Type', request.fltType),
                    _buildParamRow('Hour of Flight', '${request.hour.toString().padLeft(2, '0')}:00'),
                    _buildParamRow('Temperature', '${request.temperature2m.toStringAsFixed(1)} °C'),
                    _buildParamRow('Rainfall Volume', '${request.rain.toStringAsFixed(1)} mm'),
                    _buildParamRow('Wind Speed (10m)', '${request.windSpeed10m.toStringAsFixed(1)} km/h'),
                    _buildParamRow('Wind Gusts', '${request.windGusts10m.toStringAsFixed(1)} km/h'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ACTIONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final details = 'Flight Delay Prediction Result:\n'
                          '- Airline: ${request.airline}\n'
                          '- Prediction: ${response.prediction}\n'
                          '- Delay Probability: $probabilityPercent%\n'
                          '- Confidence: ${response.confidence}\n'
                          '- Weather Temp: ${request.temperature2m}°C\n'
                          '- Rain: ${request.rain}mm';
                      Clipboard.setData(ClipboardData(text: details));
                      Fluttertoast.showToast(msg: 'Prediction details copied to clipboard');
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Results'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.replace('/predict'),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check Another'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text(
                'Back to Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultInfoBox(BuildContext context, String title, String value, Color valueColor) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
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
