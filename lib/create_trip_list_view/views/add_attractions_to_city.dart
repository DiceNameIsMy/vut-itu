import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import '../cubit/trip_city_cubit.dart';
import '../cubit/attraction_cubit.dart';

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
  bool isBottomSheetExpanded = false; // Tracks Bottom Sheet toggle state

  @override
  void initState() {
    super.initState();
    context.read<AttractionCubit>().fetchAttractions(widget.cityId);
    context.read<TripCityCubit>().fetchTripCity(widget.tripCity.id!);
  }

  void toggleBottomSheet() {
    setState(() {
      isBottomSheetExpanded = !isBottomSheetExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City Attractions')),
      body: Stack(
        children: [
          // Main CityScreen content
          Padding(
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
                          context
                              .read<AttractionCubit>()
                              .searchAttractions(query);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
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

                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(attraction.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16),
                                      SizedBox(width: 4),
                                      Text(attraction.category),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money, size: 16),
                                      SizedBox(width: 4),
                                      Text("\$${attraction.cost.toString()}"),
                                      Spacer(),
                                      Icon(Icons.access_time_outlined,
                                          size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                          "${attraction.averageTime.toString()} minutes"),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  context
                                      .read<TripCityCubit>()
                                      .addAttractionToTripCity(attraction);
                                },
                              ),
                              onLongPress: () {
                                context
                                    .read<AttractionCubit>()
                                    .hideAttraction(attraction);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Bottom Sheet Header and Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: toggleBottomSheet,
                  child: Container(
                    color: Colors.grey[300], // Header background color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        children: [
                          // Drag handle
                          Container(
                            width: 50,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            'Selected Attractions',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isBottomSheetExpanded)
                  CityAttractionsBottomSheet(onToggle: toggleBottomSheet),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryFilterDialog extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  CategoryFilterDialog({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['All', 'Museum', 'Park', 'Historical', 'Shopping']
            .map(
              (category) => RadioListTile<String>(
                title: Text(category),
                value: category,
                groupValue: selectedCategory,
                onChanged: (value) {
                  onCategorySelected(value!);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class CityAttractionsBottomSheet extends StatelessWidget {
  final VoidCallback onToggle;

  CityAttractionsBottomSheet({required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Expanded Bottom Sheet height
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Selected Attractions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onToggle, // Collapse Bottom Sheet
                ),
              ],
            ),
          ),
          Divider(),
          // Content
          Expanded(
            child: BlocBuilder<TripCityCubit, TripCityModel>(
              builder: (context, tripCity) {
                final totalCost =
                    context.read<TripCityCubit>().calculateTotalCost();
                final totalTime =
                    context.read<TripCityCubit>().calculateTotalTime();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Total Cost: \$${totalCost.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18)),
                      Text('Total Time: ${totalTime.toStringAsFixed(2)} hours',
                          style: TextStyle(fontSize: 18)),
                      // Add additional content or widgets here
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
