import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vut_itu/map/tile_providers.dart';

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
          TextButton.icon(
            label: Text("Button"),
            icon: const Icon(Icons.search),
            onPressed: () {
              launchUrl(Uri.parse("https://duckduckgo.com/"));
            },
            style: ButtonStyle(
              iconColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          )
        ]);
  }
}
