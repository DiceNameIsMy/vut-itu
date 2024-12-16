import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/create_trip_list_view/cubit/select_places_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trips_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/search_bar_cubit.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/main_profile_screen.dart';
import '../cubit/city_cubit.dart';
import 'search_bar_city_view.dart';
import 'trip_list_view.dart';
import 'cities_list_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _showSearchBar = false;
  final GlobalKey<CitySearchBarState> _searchBarKey =
      GlobalKey<CitySearchBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                      if (_showSearchBar) {
                        _searchBarKey.currentState
                            ?.reset(); // Reset search state
                        BlocProvider.of<CityCubit>(context).fetchCities();
                      }
                    });
                  },
                  child: Text(
                      _showSearchBar ? 'Hide Search Bar' : 'Create New Trip'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<TripsCubit>(context),
                          child: TripListView(),
                        ),
                      ),
                    );
                  },
                  child: Text('My Trips'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<CityCubit>(context),
                          child: CitiesListView(),
                        ),
                      ),
                    );
                  },
                  child: Text('Cities'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(), // Profile Screen with Tabs
                      ),
                    );
                  },
                  child: Text('My Profile'),
                )
              ],
            ),
          ),
          if (_showSearchBar)
            Expanded(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => TripCubit()),
                  BlocProvider(create: (_) => SelectedPlacesCubit()),
                ],
                child: CitySearchBar(key: _searchBarKey),
              ),
            ),
        ],
      ),
    );
  }
}
