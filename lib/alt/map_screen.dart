import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/alt/map_view/map_view.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';

class MapScreen extends StatefulWidget {
  final TripModel trip;
  final List<TripCityModel> visitingPlaces;
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
  late TripCityModel _selectedPlace;
  late TripCityModel? _nextPlace;

  @override
  Widget build(BuildContext context) {
    _selectedPlace = widget.visitingPlaces.first;
    _nextPlace =
        widget.visitingPlaces.length > 1 ? widget.visitingPlaces[1] : null;

    FloatingActionButton? goToNextDestinationButton;
    if (_nextPlace != null) {
      goToNextDestinationButton = FloatingActionButton.extended(
        label: Text('Next: Unknown'), // TODO: Add _nextPlace!.title
        icon: Icon(Icons.arrow_forward),
        onPressed: () {
          print('Go to next destination');
        },
      );
    }
    return Scaffold(
        appBar: AppBar(title: Text('Next: Unknown')),
        floatingActionButton: goToNextDestinationButton,
        body: Stack(
          children: [
            MapView(
                trip: widget.trip,
                locations: [],
                centerAt: widget.centerAt,
                initZoomLevel: widget.initZoomLevel)
          ],
        ));
  }
}
