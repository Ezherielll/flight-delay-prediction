import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_viewmodel.dart'; // To get storageServiceProvider

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final storageService = ref.read(storageServiceProvider);
    final localeStr = storageService.getLocale();
    if (localeStr != null) {
      return Locale(localeStr);
    }
    // Fallback to platform locale if supported
    final platformLocale = PlatformDispatcher.instance.locale;
    if (platformLocale.languageCode == 'id') {
      return const Locale('id');
    }
    return const Locale('en');
  }

  void setLocale(Locale locale) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.setLocale(locale.languageCode);
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
