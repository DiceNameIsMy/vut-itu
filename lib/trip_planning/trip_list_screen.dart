import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip_viewmodel.dart';

class TripListScreen extends StatelessWidget {
  TripListScreen({super.key});

  final List<String> tripTitles = [
    'Trip to Europe',
    'Trip to Europe 2',
    'Trip to Tokyo',
    'Trip to Sydney',
  ];
  final List<TripViewmodel> trips = [
    TripViewmodel(id: Uuid().v7(), title: 'Trip to Europe'),
    TripViewmodel(id: Uuid().v7(), title: 'Trip to Europe2'),
    TripViewmodel(id: Uuid().v7(), title: 'Trip to Tokyo'),
    TripViewmodel(id: Uuid().v7(), title: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
      ),
      body: ListView.builder(
        itemCount: tripTitles.length,
        itemBuilder: (context, index) {
          var trip = trips[index];
          var titleColor = trip.title != null
              ? Theme.of(context).textTheme.bodyMedium?.color
              : Theme.of(context).colorScheme.secondary;
          return ListTile(
            title: Text(
              trip.title ?? "Unset",
              style: TextStyle(
                color: titleColor,
              ),
            ),
            onTap: () {
              context.go('/trips/123');
            },
          );
        },
      ),
    );
  }
}
