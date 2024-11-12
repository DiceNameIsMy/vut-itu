import 'package:flutter/material.dart';

import '../backend/settings_backend.dart';

class SettingsViewModel with ChangeNotifier {
  SettingsViewModel(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsBackend _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  late bool _completedOnboarding;
  bool get completedOnboarding => _completedOnboarding;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _completedOnboarding = await _settingsService.isOnboardingCompleted();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the completed onboarding status.
  Future<void> completeOnboarding() async {
    if (_completedOnboarding) return;

    _completedOnboarding = true;
    notifyListeners();

    await _settingsService.completeOnboarding();
  }
}
