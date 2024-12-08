import 'package:flutter/material.dart';
import 'package:vut_itu/backend/trip_model.dart';
import 'package:vut_itu/backend/visiting_place_model.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class AltTripScreen extends StatelessWidget {
  final SettingsViewModel settingsController;
  final TripModel trip;
  final List<VisitingPlaceModel> visitingPlaces;

  const AltTripScreen(
      {super.key,
      required this.trip,
      required this.visitingPlaces,
      required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(trip.title ?? 'Unnamed trip'),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back)),
          actions: [
            SettingsScreen.navigateToUsingIcon(context, settingsController)
          ],
        ),
        body: Column(
          children: [
            Text('Places:'),
            Expanded(
              child: ListView.builder(
                itemCount: visitingPlaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(visitingPlaces[index].title),
                    subtitle: Text(visitingPlaces[index].description),
                  );
                },
              ),
            )
          ],
        ));
  }
}
