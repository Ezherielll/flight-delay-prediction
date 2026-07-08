import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../core/theme/theme.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
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
      Fluttertoast.showToast(msg: 'Server URL cannot be empty');
      return;
    }
    await ref.read(settingsProvider.notifier).updateBaseUrl(newUrl);
    Fluttertoast.showToast(msg: 'API address saved: $newUrl');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.applicationSettings ?? 'Application Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API CONFIGURATION SECTION CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dns, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          l10n?.apiEndpointConfig ?? 'API Endpoint Configuration',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.apiEndpointDesc ?? 'Specify the endpoint of your FastAPI backend server. Running in Android emulator requires 10.0.2.2:8000 for localhost access.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.4,
                      ),
                    ),
                    const Divider(height: 24),
                    CustomTextField(
                      controller: _urlController,
                      label: l10n?.backendUrlLabel ?? 'Backend URL / Server IP',
                      hint: l10n?.backendUrlHint ?? 'e.g. http://10.0.2.2:8000',
                      prefixIcon: Icons.link,
                    ),
                    const SizedBox(height: 8),
                    
                    // Connection Status indicator
                    if (state.isConnected != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: state.isConnected!
                              ? AppTheme.successColor.withValues(alpha: 0.1)
                              : AppTheme.dangerColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: state.isConnected!
                                ? AppTheme.successColor.withValues(alpha: 0.3)
                                : AppTheme.dangerColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              state.isConnected!
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              color: state.isConnected!
                                  ? AppTheme.successColor
                                  : AppTheme.dangerColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      state.isConnected!
                                          ? (l10n?.connectionSuccess ?? 'Connection Test Successful!')
                                          : (l10n?.connectionFailed ?? 'Connection Test Failed'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: state.isConnected!
                                            ? AppTheme.successColor
                                            : AppTheme.dangerColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  if (!state.isConnected! && state.connectionErrorMessage != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      state.connectionErrorMessage!,
                                      style: TextStyle(
                                        color: AppTheme.dangerColor.withValues(alpha: 0.8),
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
                      const SizedBox(height: 16),
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
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.speed),
                            label: Text(state.isTestingConnection
                                ? (l10n?.testing ?? 'Testing...')
                                : (l10n?.testConnection ?? 'Test Connection')),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: l10n?.saveUrl ?? 'Save URL',
                            onPressed: state.isTestingConnection ? null : _saveUrl,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PREFERENCES SECTION CARD (DARK MODE)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: Row(
                    children: [
                      Icon(
                        state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n?.enableDarkMode ?? 'Enable Dark Mode Theme',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  subtitle: Text(l10n?.enableDarkModeDesc ?? 'Toggle between sleek dark colors and light slate layouts.'),
                  value: state.isDarkMode,
                  onChanged: (val) {
                    notifier.toggleTheme(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.language, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)?.language ?? 'Language',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n?.selectLanguageDesc ?? 'Select application language / Pilih bahasa aplikasi',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Divider(height: 24),
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
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 18),
            ),
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
