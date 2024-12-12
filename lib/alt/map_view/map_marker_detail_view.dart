import 'package:flutter/material.dart';

class MapMarkerDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Text('Place name'),
            Text('Description'),
            Text('Address'),
            Text('Phone number'),
            Text('Website'),
          ],
        ),
      ),
    );
  }
}
