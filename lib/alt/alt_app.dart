import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/trip_list/cubit/trips_cubit.dart';
import 'package:vut_itu/alt/trip_list_screen/trip_list_screen.dart';
import 'package:vut_itu/alt/onboarding_screen/onboarding_screen.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class AltApp extends StatelessWidget {
  const AltApp({super.key, required this.settingsViewModel});

  final SettingsViewModel settingsViewModel;

  @override
  Widget build(BuildContext context) {
    var themeSeedColor = Colors.deepPurple;

    var initialRoute = '/';
    if (!settingsViewModel.completedOnboarding) {
      initialRoute = '/onboarding';
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<TripsCubit>(
          create: (context) => TripsCubit()..invalidateTrips(),
        ),
      ],
      child: ListenableBuilder(
          listenable: settingsViewModel,
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
              themeMode: settingsViewModel.themeMode,

              // Routing
              routes: {
                '/': (context) => TripsScreen(settingsViewModel),
                '/onboarding': (context) =>
                    OnboardingScreen(settingsViewModel: settingsViewModel),
                '/settings': (context) =>
                    SettingsScreen(settingsController: settingsViewModel),
              },
              initialRoute: initialRoute,
            );
          }),
    );
  }
}
