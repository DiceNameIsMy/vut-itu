import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_cubit.dart';
import 'package:vut_itu/create_trip_list_view/views/home_screen_view.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/search_bar_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/city_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/attraction_cubit.dart';
import 'search_bar.dart';
import 'add_attractions_to_city.dart';

class TripCreationOverviewView extends StatelessWidget {
  final TripCubit tripCubit;
  final CityCubit cityCubit = CityCubit();
  final AttractionCubit attractionCubit = AttractionCubit();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  TripCreationOverviewView({required this.tripCubit});

  void _onNameChanged(String name, BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (name == _nameController.text) {
        context.read<TripCubit>().updateTripName(name);
      }
    });
  }

  //debounce budget update
  void _onBudgetChanged(String budget, BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (budget == _budgetController.text) {
        context
            .read<TripCubit>()
            .updateTripBudget(double.tryParse(budget) ?? 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: tripCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trip Overview'),
        ),
        body: BlocBuilder<TripCubit, TripModel>(
          builder: (context, trip) {
            _nameController.text = trip.name;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Trip Name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Trip Name',
                    ),
                    onChanged: (name) {
                      _onNameChanged(name, context);
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
                          // Add onTap to navigate to the add attractions to city view and provide attractionCubit, tripattraactionCubit and cityId
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: tripCubit,
                                  child: CityScreen(
                                    cityId: city.cityId,
                                    tripCity: city,
                                  ),
                                ),
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
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return BlocProvider(
                            create: (context) => SearchCubit<CityModel>(),
                            child: SearchBarWithSuggestions<CityModel>(
                              hintText: "Search for a city...",
                              searchType: "city",
                              onSuggestionSelected: (city) {
                                // Handle selected city
                                tripCubit.addCityToTrip(city);
                                Navigator.pop(context); // Close the search bar
                              },
                              cityId: null,
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Add New City'),
                  ),

                  // navigate to the home screen
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                      );
                    },
                    child: Text('Save'),
                  ),

                  // Budget, Start Date, End Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monetization_on, size: 16),
                          SizedBox(width: 4),

                          // Tappable Budget Text
                          GestureDetector(
                            onTap: () async {
                              final updatedBudget = await showDialog<double>(
                                context: context,
                                builder: (BuildContext context) {
                                  final budgetController =
                                      TextEditingController(
                                    text: trip.budget?.toStringAsFixed(2) ?? '',
                                  );

                                  return AlertDialog(
                                    title: Text('Update Budget'),
                                    content: TextField(
                                      controller: budgetController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        hintText: 'Enter budget',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context, null); // Cancel
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final enteredValue = double.tryParse(
                                              budgetController.text);
                                          if (enteredValue != null) {
                                            Navigator.pop(context,
                                                enteredValue); // Pass the updated budget
                                          }
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (updatedBudget != null) {
                                context.read<TripCubit>().updateTripBudget(
                                    updatedBudget); // Update the budget in the state
                              }
                            },
                            child: Text(
                              trip.budget == null
                                  ? 'Set Budget'
                                  : '\$${trip.budget!.toStringAsFixed(2)}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.date_range, size: 16),
                          SizedBox(width: 4),

                          // Start Date Picker
                          GestureDetector(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: trip.startDate ?? DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              );
                              if (selectedDate != null) {
                                context.read<TripCubit>().updateTripStartDate(
                                    selectedDate); // Update the start date
                              }
                            },
                            child: Text(
                              trip.startDate == null
                                  ? 'Select Date'
                                  : '${trip.startDate!.day}.${trip.startDate!.month}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ),

                          Text(' - ', style: TextStyle(fontSize: 18)),

                          // End Date Picker
                          GestureDetector(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: trip.endDate ?? DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              );
                              if (selectedDate != null) {
                                context.read<TripCubit>().updateTripEndDate(
                                    selectedDate); // Update the end date
                              }
                            },
                            child: Text(
                              trip.endDate == null
                                  ? 'Select Date'
                                  : '${trip.endDate!.day}.${trip.endDate!.month}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
