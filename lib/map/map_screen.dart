import 'package:flutter/material.dart';
import 'package:vut_itu/map/map_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("App bar 2")),
        body: Stack(
          children: [MapView()],
        ));
  }
}
