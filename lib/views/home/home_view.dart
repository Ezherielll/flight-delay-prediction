import 'dart:async';
import 'package:flight_delay_predict/core/theme/theme.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import 'package:flight_delay_predict/viewmodels/auth_viewmodel.dart';
import 'package:flight_delay_predict/viewmodels/prediction_viewmodel.dart';
import 'package:flight_delay_predict/viewmodels/settings_viewmodel.dart';
import 'package:flight_delay_predict/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final predictionState = ref.watch(predictionProvider);
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);

    final totalPredictions = predictionState.history.length;
    final delayedCount = predictionState.history
        .where((e) => e.response.classValue == 1)
        .length;
    final onTimeCount = totalPredictions - delayedCount;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(l10n?.appTitle ?? 'Flight Delay Estimator'),
        actions: [
          IconButton(
            icon: Icon(
              settingsState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              unawaited(settingsNotifier.toggleTheme(enabled: !settingsState.isDarkMode));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner/Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: theme.brightness == Brightness.light
                      ? [AppTheme.primaryColor, const Color(0xFF1D4ED8)]
                      : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.aiPoweredFlightIntelligence ??
                        'AI-Powered Flight Intelligence',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.aiPoweredFlightIntelligenceDesc ??
                        'Predict airline departure and arrival delays using local weather conditions and real-time operational parameters.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/predict'),
                    icon: const Icon(Icons.analytics, size: 20),
                    label: Text(l10n?.startPrediction ?? 'Start Prediction'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      elevation: 4,
                      shadowColor: Colors.black26,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.yourActivity ?? 'Your Activity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          l10n?.totalChecks ?? 'Total Checks',
                          '$totalPredictions',
                          Icons.query_stats,
                          theme.colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          l10n?.delayed ?? 'Delayed',
                          '$delayedCount',
                          Icons.warning_amber_rounded,
                          AppTheme.dangerColor,
                        ),
                      ),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          l10n?.onTime ?? 'On-Time',
                          '$onTimeCount',
                          Icons.check_circle_outline,
                          AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.quickMenu ?? 'Quick Menu',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    l10n?.predictionHistory ?? 'Prediction History',
                    l10n?.predictionHistoryDesc ??
                        'View your past delay prediction results and parameter entries.',
                    Icons.history,
                    AppTheme.infoColor,
                    () => context.push('/history'),
                  ),
                  _buildMenuCard(
                    context,
                    l10n?.serverConfiguration ?? 'Server Configuration',
                    l10n?.serverConfigurationDesc ??
                        'Configure server endpoints and verify host availability.',
                    Icons.lan_outlined,
                    AppTheme.warningColor,
                    () => context.push('/settings'),
                  ),
                  _buildMenuCard(
                    context,
                    l10n?.informationCenter ?? 'Information Center',
                    l10n?.informationCenterDesc ??
                        'Learn about aviation terms, weather variables, FAQs, and system operations.',
                    Icons.info_outline,
                    AppTheme.primaryColor,
                    () => context.push('/info'),
                  ),
                  // Admin Panel — only visible to admin users
                  if (authState.isAdmin)
                    _buildMenuCard(
                      context,
                      'Admin Panel',
                      'Manage users, roles, and view all prediction records across the system.',
                      Icons.admin_panel_settings,
                      AppTheme.warningColor,
                      () => context.push('/admin'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
