import 'package:flutter/material.dart';
import 'package:vut_itu/backend/gui_mode_enum.dart';
import 'package:vut_itu/onboarding/onboarding_screen.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/trip_alternative/alt_trip_list_screen.dart';
import 'package:vut_itu/trip_planning/trip_list_screen.dart';
import 'package:vut_itu/trip/trip_list_view_model.dart';

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.settingsController,
      required this.tripListViewModel});

  final SettingsViewModel settingsController;
  final TripListViewModel tripListViewModel;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeSeedColor = Colors.deepPurple;

    var initialRoute =
        settingsController.completedOnboarding ? '/' : '/onboarding';

    Widget homeScreen = TripListScreen();
    if (settingsController.guiMode == GuiModeEnum.alternativeMode) {
      homeScreen = AltTripListScreen(settingsController: settingsController);
    }

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Flutter Demo',

            // Theme
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: themeSeedColor),
                useMaterial3: true),
            darkTheme: ThemeData.from(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: themeSeedColor, brightness: Brightness.dark),
                useMaterial3: true),
            themeMode: settingsController.themeMode,

            // Routing
            routes: {
              '/': (context) => homeScreen,
              '/onboarding': (context) => OnboardingScreen(
                  settingsController: settingsController,
                  tripListViewModel: tripListViewModel),
              '/settings': (context) =>
                  SettingsScreen(settingsController: settingsController),
            },
            initialRoute: initialRoute,
          );
        });
  }
}
