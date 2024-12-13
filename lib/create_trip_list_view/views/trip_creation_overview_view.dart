import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
                  labelText: 'Trip Name',
                  hintText: context.read<TripCubit>().state.name,
                ),
                onChanged: (name) {
                  context.read<TripCubit>().state.name = name;
                  context.read<TripCubit>().updateTripName(name);
                },
              ),
              SizedBox(height: 16),
              // List of cities
              Expanded(
                child: BlocBuilder<TripCubit, TripModel>(
                  
                  builder: (context, trip) {
                    final screenWidth = MediaQuery.of(context).size.width;
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
                                  .removeCityFromTrip(city);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // Add new city button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement city search functionality
                },
                child: Text('Add New City'),
              ),
              SizedBox(height: 16),
              // Save button
              ElevatedButton(
                onPressed: () {
                  // Save the trip and navigate to home screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                },
                child: Text('Save'),
              ),
              SizedBox(height: 16),
              // Budget, Start Date, End Date
              BlocBuilder<TripCubit, TripModel>(
                builder: (context, trip) {
                  return Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Budget (in dollars)',
                          hintText: 'Enter budget',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (budget) {
                          try {
                            context
                                .read<TripCubit>()
                                .updateTripBudget(double.parse(budget));
                          } catch (_) {
                            // Handle invalid input gracefully
                          }
                        },
                      ),
                      Text(
                        "Start Date",
                        textAlign: TextAlign.left,
                        style: TextStyle (fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      _DatePickerField(
                        label: 'Start Date',
                        initialDate: trip.startDate ?? DateTime.now(),
                        onDateSelected: (date) {
                          context.read<TripCubit>().updateTripStartDate(date);
                        },
                      ),
                     Text(
                        "End Date",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      _DatePickerField(
                        label: 'End Date',
                        initialDate: trip.endDate ?? DateTime.now(),
                        onDateSelected: (date) {
                          context.read<TripCubit>().updateTripEndDate(date);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;


  _DatePickerField({
    required this.label,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dateFormat = DateFormat('yyyy-MM-dd');
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        width: screenWidth, // 60% of screen width for the picker
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          dateFormat.format(initialDate),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
