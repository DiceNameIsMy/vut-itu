import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/onboarding/onboarding_screen.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/alt/trip_list/trips_screen.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class AltApp extends StatelessWidget {
  const AltApp({super.key, required this.settingsController});

  final SettingsViewModel settingsController;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeSeedColor = Colors.deepPurple;

    var initialRoute =
        settingsController.completedOnboarding ? '/' : '/onboarding';

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiBlocProvider(
      providers: [
        BlocProvider<TripsCubit>(create: (context) => TripsCubit()),
      ],
      child: ListenableBuilder(
          listenable: settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              title: 'TripHub',

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
                '/': (context) => TripsScreen(settingsController),
                '/onboarding': (context) =>
                    OnboaringScreen(settingsViewModel: settingsController),
                '/settings': (context) =>
                    SettingsScreen(settingsController: settingsController),
              },
              initialRoute: initialRoute,
            );
          }),
    );
  }
}
