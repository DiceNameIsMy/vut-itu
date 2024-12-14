import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/create_trip_list_view/cubit/trip_city_cubit.dart';
import 'package:vut_itu/create_trip_list_view/cubit/attraction_cubit.dart';
import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';

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
  final AttractionCubit attractionCubit = AttractionCubit();
  final TripCityCubit tripCityCubit = TripCityCubit();

  @override
  void initState() {
    super.initState();
    context.read<AttractionCubit>().fetchAttractions(widget.cityId);
    context.read<TripCityCubit>().fetchTripCity(widget.tripCity.id!);
  }

  void _onSearchChanged(String query) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (query == _searchController.text) {
        context.read<AttractionCubit>().searchAttractions(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City Attractions')),
      body: Stack(
        children: [
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
                                  context
                                      .read<AttractionCubit>()
                                      .hideAttraction(attraction);
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
          DraggableBottomSheet(
            maxHeight: 700.0,
            animationDuration: Duration(milliseconds: 300),
            gradientOpacity: false,
            header: _bottomSheetHeader(context),
            body: _bottomSheetBody(context),
          ),
        ],
      ),
    );
  }

  Container _bottomSheetHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(66, 18, 11, 142),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      //calculate the total cost and time of the trip city and display it in the bottom sheet header in a row
      child: BlocBuilder<TripCityCubit, TripCityModel>(
        builder: (context, tripCity) {
          final totalCost = context.read<TripCityCubit>().calculateTotalCost();
          final totalTime =
              context.read<TripCityCubit>().calculateTotalTime() / 60;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.drag_handle, color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${totalCost.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${totalTime.toStringAsFixed(2)} hours',
                          style: TextStyle(fontSize: 18),
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
    );
  }

  Container _bottomSheetBody(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: 400, // Set a fixed height
        child: BlocBuilder<TripCityCubit, TripCityModel>(
          builder: (context, tripCity) {
            return ListView.builder(
              itemCount: tripCity.attractions!.length,
              itemBuilder: (context, index) {
                final attraction = tripCity.attractions![index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    title: Text(attraction.attractionId.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 4),
                            Text(attraction.attractionId.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.attach_money, size: 16),
                            SizedBox(width: 4),
                            Text("\$${attraction.expectedCost.toString()}"),
                            Spacer(),
                            Icon(Icons.access_time_outlined, size: 16),
                            SizedBox(width: 4),
                            Text(
                                "${attraction.expectedTimeToVisitInHours.toString()} minutes"),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<TripCityCubit>()
                            .removeAttractionFromTripCity(attraction);
                        context
                            .read<AttractionCubit>()
                            .fetchAttractions(widget.cityId);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
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
