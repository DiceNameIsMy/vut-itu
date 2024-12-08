import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map/map.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';

class MapScreen extends StatefulWidget {
  final TripModel trip;
  final List<VisitingPlaceModel> visitingPlaces;
  final LatLng centerAt;
  final double initZoomLevel;

  const MapScreen(
      {super.key,
      required this.trip,
      required this.visitingPlaces,
      required this.centerAt,
      this.initZoomLevel = 9});

  @override
  State<MapScreen> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  late VisitingPlaceModel _selectedPlace;
  late VisitingPlaceModel? _nextPlace;

  @override
  Widget build(BuildContext context) {
    _selectedPlace = widget.visitingPlaces.first;
    _nextPlace =
        widget.visitingPlaces.length > 1 ? widget.visitingPlaces[1] : null;

    FloatingActionButton? goToNextDestinationButton;
    if (_nextPlace != null) {
      goToNextDestinationButton = FloatingActionButton.extended(
        label: Text('Next: ${_nextPlace!.title}'),
        icon: Icon(Icons.arrow_forward),
        onPressed: () {
          print('Go to next destination');
        },
      );
    }
    return Scaffold(
        appBar: AppBar(title: const Text("App bar 2")),
        floatingActionButton: goToNextDestinationButton,
        body: Stack(
          children: [
            Map(
                trip: widget.trip,
                visitingPlace: widget.visitingPlaces.first,
                centerAt: widget.centerAt,
                initZoomLevel: widget.initZoomLevel)
          ],
        ));
  }
}
