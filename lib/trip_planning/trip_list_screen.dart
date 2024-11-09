import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/trip/trip.dart';
import 'package:vut_itu/trip/trip_viewmodel.dart';

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

            return ChangeNotifierProvider(
              create: (context) => trip,
              child: Consumer<TripViewmodel>(
                builder: (context, _, child) {
                  var trip = context.read<TripViewmodel>();
                  return ListTile(
                    title: Text(
                      trip.title ?? "Unset",
                      style: TextStyle(
                        color: titleColor,
                      ),
                    ),
                    onTap: () {
                      context.go('/trips/${trip.id}', extra: trip);
                    },
                  );
                },
              ),
            );
          },
          itemCount: trips.length),
    );
  }
}
