import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/views/search_bar_city_view.dart';
import 'package:vut_itu/create_trip_list_view/views/home_screen_view.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'search_bar_city_view.dart';
import 'add_attractions_to_city.dart';

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
        body: BlocBuilder<TripCubit, TripModel>(
          builder: (context, trip) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Trip Name
                  TextField(
                    controller: TextEditingController(text: trip.name),
                    decoration: InputDecoration(
                      labelText: 'Trip Name',
                    ),
                    onChanged: (name) {
                      context.read<TripCubit>().updateTripName(name);
                    },
                  ),
                  // List of cities
                  Expanded(
                    child: ListView.builder(
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
                                  .removeCityFromTrip(city);
                            },
                          ),
                          // Add onTap to navigate to the add attractions to city view
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return CityScreen(
                                    cityId: city.cityId,
                                  );
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
                      // Add logic to display the search bar
                    },
                    child: Text('Add New City'),
                  ),
                  // Save button to save the trip and navigate to the home screen
                  ElevatedButton(
                    onPressed: () {
                      context.read<TripCubit>().updateTrip().then((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                      });
                    },
                    child: Text('Save'),
                  ),
                  // Budget, Start Date, End Date
                  Column(
                    children: [
                      TextField(
                        controller: TextEditingController(
                            text: trip.budget?.toString() ?? ''),
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
                        controller: TextEditingController(
                            text: trip.startDate?.toIso8601String() ?? ''),
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
                        controller: TextEditingController(
                            text: trip.endDate?.toIso8601String() ?? ''),
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
            );
          },
        ),
      ),
    );
  }
}
