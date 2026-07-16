import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/app_toast.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../core/theme/theme.dart';
import '../../widgets/custom_textfield.dart';
import '../../viewmodels/locale_viewmodel.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    // Retrieve base URL from current settings state
    final settings = ref.read(settingsProvider);
    _urlController = TextEditingController(text: settings.baseUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _saveUrl() async {
    final newUrl = _urlController.text.trim();
    if (newUrl.isEmpty) {
      AppToast.show('Server URL cannot be empty', isError: true);
      return;
    }
    await ref.read(settingsProvider.notifier).updateBaseUrl(newUrl);
    AppToast.show('API address saved: $newUrl');
    // Hide keyboard
    if (!mounted) return;
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n?.applicationSettings ?? 'Application Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            notifier.resetConnectionStatus();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API CONFIGURATION SECTION
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.08 : 0.05,
                  ),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.dns_rounded,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n?.apiEndpointConfig ??
                              'API Endpoint Configuration',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n?.apiEndpointDesc ??
                          'Specify the endpoint of your FastAPI backend server. Running in Android emulator requires 10.0.2.2:8000 for localhost access.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        height: 1.4,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _urlController,
                      label: l10n?.backendUrlLabel ?? 'Backend URL / Server IP',
                      hint: l10n?.backendUrlHint ?? 'e.g. http://10.0.2.2:8000',
                      prefixIcon: Icons.link_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Connection Status indicator
                    if (state.isConnected != null) ...[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: state.isConnected!
                              ? AppTheme.successColor.withValues(alpha: 0.08)
                              : AppTheme.dangerColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: state.isConnected!
                                ? AppTheme.successColor.withValues(alpha: 0.25)
                                : AppTheme.dangerColor.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: state.isConnected!
                                    ? AppTheme.successColor.withValues(
                                        alpha: 0.15,
                                      )
                                    : AppTheme.dangerColor.withValues(
                                        alpha: 0.15,
                                      ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                state.isConnected!
                                    ? Icons.check_rounded
                                    : Icons.close_rounded,
                                color: state.isConnected!
                                    ? AppTheme.successColor
                                    : AppTheme.dangerColor,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.isConnected!
                                        ? (l10n?.connectionSuccess ??
                                              'Connection Test Successful!')
                                        : (l10n?.connectionFailed ??
                                              'Connection Test Failed'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: state.isConnected!
                                          ? AppTheme.successColor
                                          : AppTheme.dangerColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (!state.isConnected! &&
                                      state.connectionErrorMessage != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      state.connectionErrorMessage!,
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFFDA4AF)
                                            : AppTheme.dangerColor.withValues(
                                                alpha: 0.8,
                                              ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isTestingConnection
                                ? null
                                : () async {
                                    await _saveUrl();
                                    await notifier.testConnection();
                                  },
                            icon: state.isTestingConnection
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.speed_rounded, size: 18),
                            label: Text(
                              state.isTestingConnection
                                  ? (l10n?.testing ?? 'Testing...')
                                  : (l10n?.testConnection ?? 'Test Connection'),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        const Color(0xFF60A5FA),
                                        const Color(0xFF3B82F6),
                                      ]
                                    : [
                                        AppTheme.primaryColor,
                                        const Color(0xFF1D4ED8),
                                      ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: state.isTestingConnection
                                  ? null
                                  : _saveUrl,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                l10n?.saveUrl ?? 'Save URL',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PREFERENCES (DARK MODE)
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.08 : 0.05,
                  ),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          state.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n?.enableDarkMode ?? 'Enable Dark Mode Theme',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    l10n?.enableDarkModeDesc ??
                        'Toggle between sleek dark colors and light slate layouts.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  value: state.isDarkMode,
                  activeThumbColor: theme.colorScheme.primary,
                  onChanged: (val) {
                    notifier.toggleTheme(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // LANGUAGE CARD
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.08 : 0.05,
                  ),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.language_rounded,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)?.language ?? 'Language',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.selectLanguageDesc ??
                          'Select application language / Pilih bahasa aplikasi',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _buildLanguageOption(
                            context: context,
                            ref: ref,
                            languageCode: 'en',
                            label: 'English',
                            flag: '🇺🇸',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLanguageOption(
                            context: context,
                            ref: ref,
                            languageCode: 'id',
                            label: 'Bahasa Indonesia',
                            flag: '🇮🇩',
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
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required String languageCode,
    required String label,
    required String flag,
  }) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final isSelected = currentLocale.languageCode == languageCode;

    return InkWell(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.12),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check_circle,
                size: 15,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
