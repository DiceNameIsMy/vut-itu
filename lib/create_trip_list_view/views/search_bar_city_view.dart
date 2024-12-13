import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/city_cubit.dart';
import '../cubit/search_bar_cubit.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/create_trip_list_view/views/trip_creation_overview_view.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';

class CitySearchBar extends StatelessWidget {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch all cities when the widget is first loaded
    context.read<CityCubit>().fetchCities();

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
              if (cities.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    title: Text(city.name),
                    subtitle: Text(city.country),
                    onTap: () {
                      // Add the selected city to SelectedPlacesCubit
                      context.read<SelectedPlacesCubit>().addPlace(city);
                      // Optionally, refine the search
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
            onPressed: () async {
              if (selectedCities.isNotEmpty) {
                // Access the TripCubit
                final tripCubit = context.read<TripCubit>();

                // Create a new trip
                //tripCubit.updateTripName('My New Trip');
                await tripCubit.saveTrip();
                selectedCities.forEach((city) {
                  tripCubit
                      .addCityToTrip(city); // Associate cities with the trip
                });

                // Save the trip to the database
                // await tripCubit.saveTrip();

                // Navigate to the TripCreationOverviewView
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TripCreationOverviewView(tripCubit: tripCubit),
                  ),
                );
              }
            },
            child: Text('Create a Trip'),
          );
        }),
      ],
    );
  }
}
