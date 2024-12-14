import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/create_trip_list_view/cubit/city_cubit.dart';
import 'package:provider/provider.dart';
import 'views/home_screen_view.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/create_trip_list_view/cubit/select_places_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_city_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trips_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/city_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_attraction_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/attraction_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/search_bar_cubit.dart';

class Napp extends StatelessWidget {
  const Napp({Key? key, required this.settingsController}) : super(key: key);

  final SettingsViewModel settingsController;
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
                  colorScheme: ColorScheme.fromSeed(seedColor: themeSeedColor),
                  useMaterial3: true),
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
