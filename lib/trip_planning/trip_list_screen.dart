import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip.dart';
import 'package:vut_itu/trip/trip_viewmodel.dart';
import 'package:vut_itu/trip_planning/trip_screen.dart';

class TripListScreen extends StatefulWidget {
  @override
  TripListScreenState createState() => TripListScreenState();
}

class TripListScreenState extends State<TripListScreen> {
  late List<TripViewmodel> trips;

  @override
  void initState() {
    super.initState();

    // TODO: Load from somewhere
    trips = [
      TripViewmodel(TripModel(id: Uuid().v7(), title: 'Trip to Europe')),
      TripViewmodel(TripModel(id: Uuid().v7(), title: 'Trip to Europe2')),
      TripViewmodel(TripModel(id: Uuid().v7(), title: 'Trip to Tokyo')),
      TripViewmodel(TripModel(id: Uuid().v7(), title: null)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
      ),
      body: ListView.builder(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TripScreen(trip)),
                );
              },
            );
          },
          itemCount: trips.length),
    );
  }
}
