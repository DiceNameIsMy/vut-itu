import 'package:flutter/material.dart';
import 'package:vut_itu/map/map_screen.dart';
import 'package:vut_itu/trip/trip_viewmodel.dart';

class TripScreen extends StatelessWidget {
  TripScreen(this.tripViewmodel, {super.key});

  final TripViewmodel tripViewmodel;

  static final List<String> places = [
    'Prague',
    'France',
    'Rome',
  ];

  @override
  Widget build(BuildContext context) {
    return _build(context, tripViewmodel);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                icon: Icon(Icons.map)),
          );
        },
      ),
    );
  }
}
