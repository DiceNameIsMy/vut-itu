import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vut_itu/map/map_screen.dart';
import 'package:vut_itu/trip/trip_view_model.dart';

class TripScreen extends StatelessWidget {
  TripScreen(this.trip, {super.key});

  final TripViewModel trip;

  static final List<String> places = [
    'Prague',
    'France',
    'Rome',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: trip,
      child: Consumer<TripViewModel>(
        builder: (context, trip, child) {
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  MapScreen(centerAt: LatLng(51.5, -0.09))),
                        );
                      },
                      icon: Icon(Icons.map)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
