import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/map/map_view.dart';

class MapScreen extends StatefulWidget {
  final LatLng centerAt;
  final double initZoomLevel;

  const MapScreen({super.key, required this.centerAt, this.initZoomLevel = 9});

  @override
  State<MapScreen> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("App bar 2")),
        body: Stack(
          children: [
            MapView(
                centerAt: widget.centerAt, initZoomLevel: widget.initZoomLevel)
          ],
        ));
  }
}
