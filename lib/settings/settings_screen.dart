import 'package:flutter/material.dart';
import 'package:vut_itu/backend/gui_mode_enum.dart';

import 'settings_view_model.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settingsController});

  final SettingsViewModel settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: settingsController.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: settingsController.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            DropdownButton<GuiModeEnum>(
              // Read the selected themeMode from the controller
              value: settingsController.guiMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: settingsController.updateGuiMode,
              items: const [
                DropdownMenuItem(
                  value: GuiModeEnum.defaultMode,
                  child: Text('Default'),
                ),
                DropdownMenuItem(
                  value: GuiModeEnum.alternativeMode,
                  child: Text('Alternative'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget navigateToUsingIcon(
      BuildContext context, SettingsViewModel settingsController) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SettingsScreen(settingsController: settingsController);
        }));
      },
    );
  }
}
