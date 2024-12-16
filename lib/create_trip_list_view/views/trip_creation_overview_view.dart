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

  void _onBudgetChanged(String budget, BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (budget == _budgetController.text) {
        context.read<TripCubit>().updateTripBudget(double.parse(budget));
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (name) {
                      _onNameChanged(name, context);
                    },
                  ),
                  // List of cities
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        context
                            .read<TripCubit>()
                            .reorderCities(oldIndex, newIndex);
                      },
                      children: [
                        for (int index = 0; index < trip.cities.length; index++)
                          ListTile(
                            key: ValueKey(trip.cities[index].cityId),
                            title: FutureBuilder<String>(
                              future: context
                                  .read<TripCubit>()
                                  .getCityName(trip.cities[index].cityId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(snapshot.data ?? 'Unknown City');
                                }
                              },
                            ),
                            subtitle: FutureBuilder<String>(
                              future: context
                                  .read<TripCubit>()
                                  .getCityCountry(trip.cities[index].cityId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                      snapshot.data ?? 'Unknown Country');
                                }
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: const Color.fromARGB(255, 16, 8, 63),
                              ),
                              onPressed: () {
                                context
                                    .read<TripCubit>()
                                    .removeCityFromTrip(trip.cities[index]);
                              },
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<TripCubit>(),
                                    child: CityScreen(
                                      cityId: trip.cities[index].cityId,
                                      tripCity: trip.cities[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 221, 169, 91),
                      foregroundColor: const Color.fromARGB(255, 16, 8, 63),
                    ),
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
                    child: Icon(Icons.add,
                        color: const Color.fromARGB(255, 16, 8, 63)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 221, 169, 91),
                          foregroundColor: const Color.fromARGB(255, 16, 8, 63),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                          );
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ),

                  // Budget, Start Date, End Date
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
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
                                      text:
                                          trip.budget?.toStringAsFixed(2) ?? '',
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
                                            _onBudgetChanged(
                                                budgetController.text, context);
                                            Navigator.pop(
                                                context,
                                                double.parse(budgetController
                                                    .text)); // Save
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
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 4, 21, 75)),
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
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 4, 21, 75)),
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
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 4, 21, 75)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
