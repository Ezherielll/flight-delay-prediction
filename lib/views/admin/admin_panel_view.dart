import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/theme/theme.dart';
import '../../widgets/app_drawer.dart';
import '../../core/services/export_service.dart';
import 'widgets/analytics_tab.dart';

class AdminPanelView extends ConsumerStatefulWidget {
  const AdminPanelView({super.key});

  @override
  ConsumerState<AdminPanelView> createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends ConsumerState<AdminPanelView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    // Fetch data when the view is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminProvider.notifier).fetchAllUsers();
      ref.read(adminProvider.notifier).fetchAllPredictions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adminState = ref.watch(adminProvider);

    // Listen for errors and show snackbar
    ref.listen<AdminState>(adminProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.dangerColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        ref.read(adminProvider.notifier).clearError();
      }
    });

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          if (_tabController.index != 0 && adminState.allPredictions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Export All Predictions to CSV',
              onPressed: () {
                ExportService.exportRecordsToCsv(adminState.allPredictions);
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(adminProvider.notifier).fetchAllUsers();
              ref.read(adminProvider.notifier).fetchAllPredictions();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.analytics), text: 'All Predictions'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserManagementTab(context, adminState),
          _buildAllPredictionsTab(context, adminState),
          AnalyticsTab(predictions: adminState.allPredictions),
        ],
      ),
    );
  }

  // ── User Management Tab ───────────────────────────────────────────────────

  Widget _buildUserManagementTab(BuildContext context, AdminState state) {
    final theme = Theme.of(context);

    if (state.isLoadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    final currentUserId = ref.read(authProvider).user?.id;

    return RefreshIndicator(
      onRefresh: () => ref.read(adminProvider.notifier).fetchAllUsers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final userRole = state.users[index];
          final isCurrentUser = userRole.userInfoId == currentUserId;
          final isAdmin = userRole.role == 'admin';

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            color: theme.colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isCurrentUser
                    ? theme.colorScheme.primary.withValues(alpha: 0.3)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                width: isCurrentUser ? 2.0 : 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isAdmin
                          ? AppTheme.warningColor.withValues(alpha: 0.15)
                          : theme.colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isAdmin ? Icons.admin_panel_settings : Icons.person,
                      color: isAdmin
                          ? AppTheme.warningColor
                          : theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'User #${userRole.userInfoId}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isCurrentUser) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'You',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isAdmin
                                ? AppTheme.warningColor.withValues(alpha: 0.12)
                                : AppTheme.infoColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isAdmin ? 'Administrator' : 'Petugas AMC',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isAdmin
                                  ? AppTheme.warningColor
                                  : AppTheme.infoColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Actions (disabled for current user)
                  if (!isCurrentUser)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'toggle_role':
                            _showToggleRoleDialog(
                              context,
                              userRole.userInfoId,
                              userRole.role,
                            );
                            break;
                          case 'delete':
                            _showDeleteDialog(context, userRole.userInfoId);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle_role',
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.swap_horiz),
                            title: Text(
                              isAdmin ? 'Set as AMC' : 'Set as Admin',
                            ),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.delete, color: AppTheme.dangerColor),
                            title: Text(
                              'Delete User',
                              style: TextStyle(color: AppTheme.dangerColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showToggleRoleDialog(
    BuildContext context,
    int userId,
    String currentRole,
  ) {
    final newRole = currentRole == 'admin' ? 'amc' : 'admin';
    final newRoleLabel = newRole == 'admin' ? 'Administrator' : 'Petugas AMC';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Role'),
        content: Text(
          'Change User #$userId\'s role to $newRoleLabel?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(adminProvider.notifier).updateRole(userId, newRole);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete User #$userId? '
          'This will remove their role, profile, and all prediction records. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(adminProvider.notifier).deleteUser(userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── All Predictions Tab ───────────────────────────────────────────────────

  Widget _buildAllPredictionsTab(BuildContext context, AdminState state) {
    final theme = Theme.of(context);

    if (state.isLoadingPredictions) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.allPredictions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No predictions found',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(adminProvider.notifier).fetchAllPredictions(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.allPredictions.length,
        itemBuilder: (context, index) {
          final record = state.allPredictions[index];
          final isDelayed = record.prediction == 'Delayed';

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            color: theme.colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'User #${record.userInfoId}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDelayed
                              ? AppTheme.dangerColor.withValues(alpha: 0.12)
                              : AppTheme.successColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          record.prediction,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDelayed
                                ? AppTheme.dangerColor
                                : AppTheme.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Details
                  Row(
                    children: [
                      _buildDetailChip(
                        context,
                        Icons.flight,
                        record.airline,
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        context,
                        Icons.calendar_today,
                        record.date,
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        context,
                        Icons.speed,
                        '${(record.probability * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
