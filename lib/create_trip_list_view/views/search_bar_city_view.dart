import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/city_cubit.dart';
import '../cubit/search_bar_cubit.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/create_trip_list_view/views/trip_creation_overview_view.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';

class CitySearchBar extends StatefulWidget {
  CitySearchBar({super.key});

  @override
  CitySearchBarState createState() => CitySearchBarState();
}

class CitySearchBarState extends State<CitySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false; // Add loading state

  void reset() {
    _searchController.clear();
    BlocProvider.of<CityCubit>(context).fetchCities();
    BlocProvider.of<SelectedPlacesCubit>(context).clearPlaces();
    context.read<TripCubit>().resetTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Cities',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              context.read<CityCubit>().searchCities(query);
            },
          ),
        ),
        BlocBuilder<SelectedPlacesCubit, List<CityModel>>(
          builder: (context, selectedCities) {
            return Wrap(
              spacing: 8.0,
              children: selectedCities.map((city) {
                return Chip(
                  label: Text(city.name),
                  onDeleted: () {
                    context.read<SelectedPlacesCubit>().removePlace(city);
                  },
                );
              }).toList(),
            );
          },
        ),
        Expanded(
          child: BlocBuilder<CityCubit, List<CityModel>>(
            builder: (context, cities) {
              if (_isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (cities.isEmpty) {
                return Center(child: Text('No cities found.'));
              }

              return ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    title: Text(city.name),
                    subtitle: Text(city.country),
                    onTap: () {
                      context.read<SelectedPlacesCubit>().addPlace(city);
                      context
                          .read<CityCubit>()
                          .searchCities(_searchController.text);
                    },
                  );
                },
              );
            },
          ),
        ),
        BlocBuilder<SelectedPlacesCubit, List<CityModel>>(
            builder: (context, selectedCities) {
          return ElevatedButton(
            onPressed: selectedCities.isEmpty || _isLoading
                ? null // Disable if no cities or loading
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      final tripCubit = context.read<TripCubit>();

                      await tripCubit.saveTrip();
                      for (final city in selectedCities) {
                        await tripCubit.addCityToTrip(city);
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              TripCreationOverviewView(tripCubit: tripCubit),
                        ),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
            child: Text('Create a Trip'),
          );
        }),
      ],
    );
  }
}
