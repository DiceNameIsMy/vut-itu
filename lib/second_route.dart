import 'package:flutter/material.dart';
import 'package:vut_itu/map/map_view.dart';

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("App bar 2")),
        body: Stack(
          children: [MapView()],
        ));
  }
}
