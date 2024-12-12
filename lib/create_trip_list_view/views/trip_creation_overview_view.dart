/* Screen that displays the trip overview: at the top of the screen there is a trip name that could be modified as is set to Trip name by default
beneath it there is the list of the cities that are already added to that trip, they could be removed from the trip
beneath the list of the cities there is a add new city button that will display the search bar to search for another city
at the bottom of the screen there is a widget that contains the budget section and the start date and the end day of the trip the default values are set for 0 dollars and today date */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/views/search_bar_city_view.dart';
import 'package:vut_itu/create_trip_list_view/views/home_screen_view.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'search_bar_city_view.dart';

class TripCreationOverviewView extends StatelessWidget {
  final TripCubit tripCubit;

  TripCreationOverviewView({required this.tripCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: tripCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trip Creation Overview'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Trip Name
              TextField(
                decoration: InputDecoration(
                  labelText: context.read<TripCubit>().state.name,
                ),
                onChanged: (name) {
                  context.read<TripCubit>().updateTripName(name);
                },
              ),
              // List of cities
              Expanded(
                child: BlocBuilder<TripCubit, TripModel>(
                  builder: (context, trip) {
                    return ListView.builder(
                      itemCount: trip.cities.length,
                      itemBuilder: (context, index) {
                        final city = trip.cities[index];
                        return ListTile(
                          title: FutureBuilder<String>(
                            future: context
                                .read<TripCubit>()
                                .getCityName(city.cityId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(snapshot.data ?? 'Unknown City');
                              }
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context
                                  .read<TripCubit>()
                                  .removeCityFromTrip(city.cityId);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Add new city button
              ElevatedButton(
                onPressed: () {
                  //add search bar
                },
                child: Text('Add New City'),
              ),
              //save button to save the trip and navigate to the home screen
              ElevatedButton(
                onPressed: () {
                  //save the trip
                  //navigate to the home screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                },
                child: Text('Save'),
              ),
              // Budget, Start Date, End Date
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Budget',
                    ),
                    onChanged: (budget) {
                      context
                          .read<TripCubit>()
                          .updateTripBudget(double.parse(budget));
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                    ),
                    onChanged: (startDate) {
                      context
                          .read<TripCubit>()
                          .updateTripStartDate(DateTime.parse(startDate));
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'End Date',
                    ),
                    onChanged: (endDate) {
                      context
                          .read<TripCubit>()
                          .updateTripEndDate(DateTime.parse(endDate));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
