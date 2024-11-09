import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vut_itu/trip/trip_viewmodel.dart';

class TripScreen extends StatelessWidget {
  TripScreen({super.key});

  static final List<String> places = [
    'Prague',
    'France',
    'Rome',
  ];

  @override
  Widget build(BuildContext context) {
    var trip = context.watch<TripViewmodel?>();
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Places List")),
        body: Center(
          child: Text('Trip not found'),
        ),
      );
    }
    return _build(context, trip);
  }

  Widget _build(BuildContext context, TripViewmodel trip) {
    var titleText =
        trip.title == null ? 'Places List' : '${trip.title} Places List';
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index]),
            trailing: IconButton(
                onPressed: () {
                  context.go('/trips/${trip.id}/map', extra: trip);
                },
                icon: Icon(Icons.map)),
          );
        },
      ),
    );
  }
}
