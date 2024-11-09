import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripScreen extends StatelessWidget {
  final List<String> places = [
    'Prague',
    'France',
    'Rome',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places List'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index]),
            trailing: IconButton(
                onPressed: () {
                  context.go('/trips/123/map');
                },
                icon: Icon(Icons.map)),
          );
        },
      ),
    );
  }
}
