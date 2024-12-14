import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import '../cubit/trip_city_cubit.dart';
import 'package:vut_itu/backend/business_logic/trip_attractions_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/search_bar_cubit.dart';
import 'search_bar.dart';
import '../cubit/attraction_cubit.dart';
import '../cubit/trip_attraction_cubit.dart';

class CityScreen extends StatefulWidget {
  final int cityId;
  final TripCityModel tripCity;

  CityScreen({required this.cityId, required this.tripCity});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final _searchController = TextEditingController();
  String selectedCategory = 'All';
  bool showDeletedAttractions = false;

  @override //init state to fetch attractions asu
  void initState() {
    super.initState();
    // Fetch attractions
    context.read<AttractionCubit>().fetchAttractions(widget.cityId);
    context.read<TripCityCubit>().fetchTripCity(widget.tripCity.id!);
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
                        subtitle: Text(attraction.cost.toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Add to trip city

                            context
                                .read<TripCityCubit>()
                                .addAttractionToTripCity(attraction);
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
            BlocBuilder<TripCityCubit, TripCityModel>(
              builder: (context, tripCities) {
                final totalCost =
                    context.read<TripCityCubit>().calculateTotalCost();
                final totalTime =
                    context.read<TripCityCubit>().calculateTotalTime();

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
                    context
                        .read<TripCityCubit>()
                        .updateTripCityStartDate(selectedDate);
                  }
                });
              },
              child: Text('Add Start Date'),
            ),
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
                    context
                        .read<TripCityCubit>()
                        .updateTripCityEndDate(selectedDate);
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
