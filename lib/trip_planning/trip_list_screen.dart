import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripListScreen extends StatelessWidget {
  final List<String> trips = [
    'Trip to Europe',
    'Trip to Europe 2',
    'Trip to Tokyo',
    'Trip to Sydney',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(trips[index]),
            onTap: () {
              context.go('/trips/123');
            },
          );
        },
      ),
    );
  }
}
