import 'dart:async';

import 'package:flight_delay_predict/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, this.message});

  final String? message;

  static void show(BuildContext context, {String? message}) {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoadingDialog(message: message),
      ),
    );
  }

  static void hide(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final displayMessage =
        message ?? l10n?.estimatingDelay ?? 'Estimating flight delay...';

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 36,
                width: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  displayMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
