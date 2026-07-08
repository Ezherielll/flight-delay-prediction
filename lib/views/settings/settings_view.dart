import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../core/theme/theme.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

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
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
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
                        const Text(
                          'API Endpoint Configuration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Specify the endpoint of your FastAPI backend server. Running in Android emulator requires 10.0.2.2:8000 for localhost access.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        height: 1.4,
                      ),
                    ),
                    const Divider(height: 24),
                    CustomTextField(
                      controller: _urlController,
                      label: 'Backend URL / Server IP',
                      hint: 'e.g. http://10.0.2.2:8000',
                      prefixIcon: Icons.link,
                    ),
                    const SizedBox(height: 8),
                    
                    // Connection Status indicator
                    if (state.isConnected != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: state.isConnected!
                              ? AppTheme.successColor.withOpacity(0.1)
                              : AppTheme.dangerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: state.isConnected!
                                ? AppTheme.successColor.withOpacity(0.3)
                                : AppTheme.dangerColor.withOpacity(0.3),
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
                                        ? 'Connection Test Successful!'
                                        : 'Connection Test Failed',
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
                                        color: AppTheme.dangerColor.withOpacity(0.8),
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
                                ? 'Testing...'
                                : 'Test Connection'),
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
                            text: 'Save URL',
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
                      const Text(
                        'Enable Dark Mode Theme',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  subtitle: const Text('Toggle between sleek dark colors and light slate layouts.'),
                  value: state.isDarkMode,
                  onChanged: (val) {
                    notifier.toggleTheme(val);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
