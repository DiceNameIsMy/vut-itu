import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map/map.dart';
import 'package:vut_itu/backend/trip_model.dart';

class MapScreen extends StatefulWidget {
  final TripModel trip;
  final LatLng centerAt;
  final double initZoomLevel;

  const MapScreen(
      {super.key,
      required this.trip,
      required this.centerAt,
      this.initZoomLevel = 9});

  @override
  State<MapScreen> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    var goToNextDestinationButton = FloatingActionButton.extended(
      label: Text('Next: Tokyo'),
      icon: Icon(Icons.arrow_forward),
      onPressed: () {
        print('Go to next destination');
      },
    );

    return Scaffold(
        appBar: AppBar(title: const Text("App bar 2")),
        floatingActionButton: goToNextDestinationButton,
        body: Stack(
          children: [
            Map(
                trip: widget.trip,
                centerAt: widget.centerAt,
                initZoomLevel: widget.initZoomLevel)
          ],
        ));
  }
}
