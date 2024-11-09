import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vut_itu/map/tile_providers.dart';
import 'package:vut_itu/search_button.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapView();
}

class _MapView extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(51.5, -0.09),
          initialZoom: 5,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
        ),
        children: [
          openStreetMapTileLayer,
          SearchButton(
              onPressed: () {
                launchUrl(Uri.parse("https://duckduckgo.com/"));
              },
              label: "Search")
        ]);
  }
}
