import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_city_cubit.dart';
import '../cubit/city_cubit.dart';
import 'search_bar_city_view.dart';
import 'trip_list_view.dart';
import '../cubit/trips_cubit.dart';
import 'cities_list_view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _showSearchBar = false;

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
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                    });
                    if (_showSearchBar) {
                      BlocProvider.of<CityCubit>(context).fetchCities();
                    }
                  },
                  child: Text(
                      _showSearchBar ? 'Hide Search Bar' : 'Create New Trip'),
                ),
                SizedBox(height: 8),
                //My trips button to navigate to the trip list view with trips cubit with all the trips
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

                //Cities button to navigate to the cities list view with city cubit with all the cities
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
              ],
            ),
          ),
          if (_showSearchBar)
            Expanded(child: CitySearchBar()), // Display the search bar
        ],
      ),
    );
  }
}
