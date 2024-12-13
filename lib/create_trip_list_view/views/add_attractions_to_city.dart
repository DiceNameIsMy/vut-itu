import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import '../cubit/trip_city_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';
import '../cubit/attraction_cubit.dart';
import '../cubit/trip_attraction_cubit.dart';

class CityScreen extends StatefulWidget {
  final int cityId;

  CityScreen({required this.cityId});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final _searchController = TextEditingController();
  String selectedCategory = 'All';
  bool showDeletedAttractions = false;

  @override
  void initState() {
    super.initState();
    // Fetch attractions and trip city data
    context.read<AttractionCubit>().fetchAttractions(widget.cityId);
    context
        .read<TripCityCubit>()
        .fetchTripCities(1); // Replace with actual trip ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City Attractions')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search and Filter Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration:
                        InputDecoration(labelText: 'Search Attractions'),
                    onChanged: (query) {
                      context.read<AttractionCubit>().searchAttractions(query);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Open category filter dialog
                    showDialog(
                      context: context,
                      builder: (_) => CategoryFilterDialog(
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                          context
                              .read<AttractionCubit>()
                              .filterAttractionsByCategory(category);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            // List of Attractions
            Expanded(
              child: BlocBuilder<AttractionCubit, List<AttractionModel>>(
                builder: (context, attractions) {
                  final filteredAttractions =
                      showDeletedAttractions ? attractions : attractions;

                  return ListView.builder(
                    itemCount: filteredAttractions.length,
                    itemBuilder: (context, index) {
                      final attraction = filteredAttractions[index];

                      return ListTile(
                        title: Text(attraction.name),
                        subtitle: Text(attraction.category),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Add to trip city
                            final tripCity = context
                                .read<TripCityCubit>()
                                .state
                                .firstWhere(
                                    (city) => city.cityId == widget.cityId);
                            final tripAttraction = TripAttractionModel(
                              attractionId: attraction.id!,
                              tripCityId: tripCity.id!,
                              order: (tripCity.attractions?.length ?? 0) + 1,

                              // Add other necessary fields here
                            );
                            context
                                .read<TripCityCubit>()
                                .addAttractionToTripCity(
                                    tripCity, tripAttraction);
                          },
                        ),
                        onLongPress: () {
                          // Hide Attraction
                          context
                              .read<AttractionCubit>()
                              .hideAttraction(attraction);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Show deleted attractions toggle
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showDeletedAttractions = !showDeletedAttractions;
                });
              },
              child: Text(showDeletedAttractions
                  ? 'Hide Deleted Attractions'
                  : 'Show Deleted Attractions'),
            ),
            // Total Time and Cost
            BlocBuilder<TripCityCubit, List<TripCityModel>>(
              builder: (context, tripCities) {
                final tripCity = tripCities
                    .firstWhere((city) => city.cityId == widget.cityId);
                final totalCost =
                    context.read<TripCityCubit>().calculateTotalCost(tripCity);
                final totalTime =
                    context.read<TripCityCubit>().calculateTotalTime(tripCity);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
                      Text('Total Time: ${totalTime.toStringAsFixed(2)} hours'),
                    ],
                  ),
                );
              },
            ),
            // Add Visit Dates
            ElevatedButton(
              onPressed: () {
                // Navigate to a date picker or add visit date functionality
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    final tripCity = context
                        .read<TripCityCubit>()
                        .state
                        .firstWhere((city) => city.cityId == widget.cityId);
                    context
                        .read<TripCityCubit>()
                        .updateStartDate(tripCity, selectedDate);
                  }
                });
              },
              child: Text('Add Start Date'),
            ),

            //add end date
            ElevatedButton(
              onPressed: () {
                // Navigate to a date picker or add visit date functionality
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    final tripCity = context
                        .read<TripCityCubit>()
                        .state
                        .firstWhere((city) => city.cityId == widget.cityId);
                    context
                        .read<TripCityCubit>()
                        .updateEndDate(tripCity, selectedDate);
                  }
                });
              },
              child: Text('Add End Date'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilterDialog extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  CategoryFilterDialog(
      {required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['All', 'Museum', 'Park', 'Historical', 'Shopping']
            .map((category) => RadioListTile<String>(
                  title: Text(category),
                  value: category,
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    onCategorySelected(value!);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }
}
