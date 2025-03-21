import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/create_trip_list_view/cubit/city_cubit.dart';
import 'views/home_screen_view.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/create_trip_list_view/cubit/select_places_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_city_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trips_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_attraction_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/attraction_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/search_bar_cubit.dart';

class Napp extends StatelessWidget {
  const Napp({Key? key, required this.settingsController}) : super(key: key);

  final SettingsViewModel settingsController;
  @override
  Widget build(BuildContext context) {
    var themeSeedColor = const Color.fromARGB(255, 224, 138, 17);
    Color primaryColor = const Color.fromARGB(255, 229, 152, 28);
    Color secondaryColor = const Color.fromARGB(255, 9, 10, 68);

    var initialRoute =
        settingsController.completedOnboarding ? '/' : '/onboarding';

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiBlocProvider(
      providers: [
        BlocProvider<CityCubit>(create: (context) => CityCubit()),
        BlocProvider<SelectedPlacesCubit>(
            create: (context) => SelectedPlacesCubit()),

        //block provider for TripCubit
        BlocProvider<TripCubit>(create: (context) => TripCubit()),
        BlocProvider<TripsCubit>(create: (context) => TripsCubit()),
        BlocProvider<TripCityCubit>(create: (context) => TripCityCubit()),
        BlocProvider<CityCubit>(create: (context) => CityCubit()),
        BlocProvider<TripAttractionCubit>(
            create: (context) => TripAttractionCubit()),
        BlocProvider<AttractionCubit>(create: (context) => AttractionCubit()),
        BlocProvider<SelectedPlacesCubit>(
            create: (context) => SelectedPlacesCubit()),
        BlocProvider<SearchCubit>(create: (context) => SearchCubit()),
      ],
      child: ListenableBuilder(
          listenable: settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              title: 'TripHub',

              // Theme
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
                  secondary: secondaryColor,
                  surface: const Color.fromARGB(
                      255, 255, 255, 255), // Example for surface color
                ),
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                      fontFamily: 'Roboto', fontSize: 16), // Body text font
                  bodyMedium: TextStyle(
                      fontFamily: 'Roboto', fontSize: 14), // Smaller body text
                  headlineLarge: TextStyle(
                      fontFamily: 'Roboto', fontSize: 24), // Headline font
                  titleLarge: TextStyle(
                      fontFamily: 'Roboto', fontSize: 20), // App bar title font
                ),
                useMaterial3: true,
              ),

              darkTheme: ThemeData.from(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: themeSeedColor, brightness: Brightness.dark),
                  useMaterial3: true),
              themeMode: settingsController.themeMode,

              // Routing
              routes: {
                '/': (context) => MainScreen(),
                '/onboarding': (context) => MainScreen(),
                '/settings': (context) =>
                    SettingsScreen(settingsController: settingsController),
              },
              initialRoute: initialRoute,
            );
          }),
    );
  }
}
