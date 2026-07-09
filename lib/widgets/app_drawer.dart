import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import '../core/theme/theme.dart';
import '../viewmodels/auth_viewmodel.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);

    // Get the current route path to highlight the active menu item
    final String currentRoute = GoRouterState.of(context).uri.path;

    return Drawer(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Header with nice gradient
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [AppTheme.primaryColor, const Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.airplanemode_active,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  authState.user?.userName ?? 'Flight Intelligence',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authState.user?.email ?? 'Kualanamu International (KNO)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Navigation list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                _buildDrawerItem(
                  context: context,
                  title: l10n?.home ?? 'Dashboard Home',
                  icon: Icons.dashboard_rounded,
                  route: '/home',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  title: l10n?.flightDelayPrediction ?? 'Run prediction',
                  icon: Icons.online_prediction_rounded,
                  route: '/predict',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  title: l10n?.history ?? 'Estimation History',
                  icon: Icons.history_rounded,
                  route: '/history',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  title: l10n?.infoCenter ?? 'Information Center',
                  icon: Icons.info_outline_rounded,
                  route: '/info',
                  currentRoute: currentRoute,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Divider(),
                ),
                _buildDrawerItem(
                  context: context,
                  title: l10n?.settings ?? 'Settings',
                  icon: Icons.settings_rounded,
                  route: '/settings',
                  currentRoute: currentRoute,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Divider(),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: AppTheme.dangerColor,
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.dangerColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(authProvider.notifier).signOut();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${l10n?.version ?? 'Version'} 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        onTap: () {
          // Close drawer
          Navigator.pop(context);
          // Navigate to route if not already there
          if (!isSelected) {
            context.go(route);
          }
        },
      ),
    );
  }
}
