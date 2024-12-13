import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vut_itu/backend/gui_mode_enum.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsBackend {
  late SharedPreferencesAsync _prefs;

  SettingsBackend() {
    _prefs = SharedPreferencesAsync();
  }

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    var themeMode = await _prefs.getInt('themeMode');
    themeMode ??= ThemeMode.system.index;

    return ThemeMode.values[themeMode];
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> setThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    await _prefs.setInt('themeMode', theme.index);
  }

  Future<bool> onboardingCompleted() async {
    var completed = await _prefs.getBool('onboardingCompleted');
    completed ??= false;

    return completed;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool('onboardingCompleted', completed);
  }

  Future<GuiModeEnum> guiMode() async {
    var guiMode = await _prefs.getInt('guiMode');
    guiMode ??= GuiModeEnum.defaultMode.index;

    return GuiModeEnum.values[guiMode];
  }

  Future<void> setGuiMode(GuiModeEnum newGuiMode) async {
    await _prefs.setInt('guiMode', newGuiMode.index);
  }

  Future<String> geoapifyApiKey() async {
    var geoapifyApiKey = await _prefs.getString('geoapifyApiKey');
    if (geoapifyApiKey != null && geoapifyApiKey != '') {
      return geoapifyApiKey;
    }

    if (const bool.hasEnvironment('GEOAPIFY_API_KEY')) {
      return const String.fromEnvironment('GEOAPIFY_API_KEY');
    }

    // TODO: Proper error handling
    throw Exception('Geoapify API key not found');
  }

  Future<void> setGeoapifyApiKey(String newApiKey) async {
    await _prefs.setString('geoapifyApiKey', newApiKey);
  }
}
