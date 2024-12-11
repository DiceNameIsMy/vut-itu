import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'city_cubit.dart';
import 'search_bar_city.dart';

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
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showSearchBar = !_showSearchBar;
                });
                if (_showSearchBar) {
                  BlocProvider.of<CityCubit>(context).fetchCities();
                }
              },
              child: Text(_showSearchBar ? 'Hide Search Bar' : 'Create New Trip'),
            ),
          ),
          if (_showSearchBar)
            Expanded(child: CitySearchBar()), // Display the search bar
        ],
      ),
    );
  }
}
