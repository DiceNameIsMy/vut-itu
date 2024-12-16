import 'package:flutter/material.dart';

class MapMarkerDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
