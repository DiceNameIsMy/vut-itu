import 'package:flutter/material.dart';
import 'package:vut_itu/backend/business_logic/trip_cities_model.dart';
import 'package:vut_itu/backend/business_logic/trip_model.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class TripScreen extends StatelessWidget {
  final SettingsViewModel settingsController;
  final TripModel trip;
  final List<TripCityModel> visitingPlaces;

  const TripScreen(
      {super.key,
      required this.trip,
      required this.visitingPlaces,
      required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(trip.name),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back)),
          actions: [
            SettingsScreen.navigateToUsingIcon(context, settingsController)
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: Icon(Icons.add),
          label: const Text('Add next destination'),
        ),
        body: Column(
          children: [
            Text('Places:'),
            Expanded(
              child: ListView.builder(
                itemCount: visitingPlaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text("Unknown"), // TODO: Add visitingPlaces[index].name
                    subtitle: Text(
                        "Unknown"), // TODO: Add visitingPlaces[index].description
                  );
                },
              ),
            )
          ],
        ));
  }
}
