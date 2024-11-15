import 'package:flutter/material.dart';
import 'package:vut_itu/settings/settings_screen.dart';
import 'package:vut_itu/settings/settings_view_model.dart';
import 'package:vut_itu/trip_alternative/alt_trip_view_model.dart';

class AltTripScreen extends StatefulWidget {
  final SettingsViewModel settingsController;
  final String tripId;

  const AltTripScreen(
      {super.key, required this.tripId, required this.settingsController});

  @override
  State<AltTripScreen> createState() => _AltTripScreenState();
}

class _AltTripScreenState extends State<AltTripScreen> {
  late AltTripViewModel trip = AltTripViewModel(widget.tripId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: trip.loadTrip(),
        builder: (context, snapshot) {
          var loaded = false;
          if (snapshot.connectionState == ConnectionState.waiting) {
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null && snapshot.data == false) {
              return Center(child: Text('No data available'));
            } else {
              loaded = true;
            }
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(loaded ? trip.title : 'Loading...'),
                leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back)),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SettingsScreen(
                            settingsController: widget.settingsController);
                      }));
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  Text('Places:'),
                  loaded
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: trip.places.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(trip.places[index].title),
                                subtitle: Text(trip.places[index].description),
                              );
                            },
                          ),
                        )
                      : Text('Loading...'),
                ],
              ));
        });
  }
}
