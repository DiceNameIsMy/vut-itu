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
    context.read<TripCityCubit>().fetchTripCity(widget.tripCity.id);
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
                          decoration: InputDecoration(
                            labelText: 'Search Attractions',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: _onSearchChanged),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: const Color.fromARGB(255, 16, 8, 63),
                      ),
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
                                icon: Icon(
                                  Icons.add,
                                  color: const Color.fromARGB(255, 16, 8, 63),
                                ),
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
        //top left and right corners of the bottom sheet
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(20),
        ),

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
                        Icon(
                          Icons.attach_money,
                          size: 16,
                          color: const Color.fromARGB(255, 16, 8, 63),
                        ),
                        SizedBox(width: 3),
                        Text(
                          '${totalCost.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 16, 8, 63)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: const Color.fromARGB(255, 16, 8, 63),
                        ),
                        SizedBox(width: 3),
                        Text(
                          '${totalTime.toStringAsFixed(2)} hours',
                          style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 16, 8, 63)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 16,
                          color: const Color.fromARGB(255, 16, 8, 63),
                        ),
                        SizedBox(width: 4),

                        // Start Date Picker
                        GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: tripCity.startDate ?? DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              context
                                  .read<TripCityCubit>()
                                  .updateTripCityStartDate(
                                      selectedDate); // Update the start date
                            }
                          },
                          child: Text(
                            tripCity.startDate == null
                                ? 'Enter date'
                                : '${tripCity.startDate!.day}.${tripCity.startDate!.month}',
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 16, 8, 63)),
                          ),
                        ),

                        Text(' - ', style: TextStyle(fontSize: 18)),

                        // End Date Picker
                        GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: tripCity.endDate ?? DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              context
                                  .read<TripCityCubit>()
                                  .updateTripCityEndDate(
                                      selectedDate); // Update the end date
                            }
                          },
                          child: Text(
                            tripCity.endDate == null
                                ? 'Enter date'
                                : '${tripCity.endDate!.day}.${tripCity.endDate!.month}',
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 16, 8, 63)),
                          ),
                        ),
                      ],
                    )
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
      child: BlocBuilder<TripCityCubit, TripCityModel>(
        builder: (context, tripCity) {
          if (tripCity.attractions == null || tripCity.attractions!.isEmpty) {
            return Center(
              child: Text(
                'No attractions available.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return SizedBox(
            height: 400,
            child: ReorderableListView.builder(
              itemCount: tripCity.attractions!.length,
              onReorder: (oldIndex, newIndex) {
                context
                    .read<TripCityCubit>()
                    .reorderAttractions(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final attraction = tripCity.attractions![index];
                return Container(
                  key: ValueKey(attraction.id),
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
                    title: FutureBuilder<String>(
                      future: context
                          .read<TripCityCubit>()
                          .getAttractionNameById(attraction.attractionId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? 'Unknown Attraction');
                        }
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 4),
                            FutureBuilder<String>(
                              future: context
                                  .read<TripCityCubit>()
                                  .getAttractionCategoryById(
                                      attraction.attractionId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                      snapshot.data ?? 'Unknown Category');
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.attach_money, size: 16),
                            SizedBox(width: 4),
                            Text("${attraction.expectedCost.toString()}"),
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
                      icon: Icon(
                        Icons.delete,
                        color: const Color.fromARGB(255, 16, 8, 63),
                      ),
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
            ),
          );
        },
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
